const express = require('express');
const { chromium } = require('playwright');
const app = express();

// Configure body parser to handle large HTML payloads
app.use(express.json({ limit: '50mb' }));

// Cloud Run Health Check
app.get('/', (req, res) => {
  res.status(200).send('PDF Engine is running');
});

/**
 * Endpoint: POST /generate-pdf
 * Body: { html: string }
 */
app.post('/generate-pdf', async (req, res) => {
  const { html } = req.body;

  if (!html) {
    return res.status(400).send('Missing HTML content');
  }

  let browser;
  try {
    browser = await chromium.launch({
      args: [
        '--no-sandbox',
        '--disable-setuid-sandbox',
        '--disable-dev-shm-usage'
      ]
    });

    const context = await browser.newContext();
    const page = await context.newPage();

    // Set content and wait for network to be idle (useful if there are external images/fonts)
    await page.setContent(html, { waitUntil: 'networkidle' });

    // Generate PDF options
    const paperSize = req.body.paperSize || 'a4';
    const pdfOptions = {
      printBackground: true,
      margin: { top: '0px', right: '0px', bottom: '0px', left: '0px' }
    };

    if (paperSize === 'continuous') {
      // For continuous mode, calculate the content height
      const contentHeight = await page.evaluate(() => {
        const body = document.body;
        const html = document.documentElement;
        return Math.max(body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight);
      });
      pdfOptions.width = '794px'; // Maintain A4 width
      pdfOptions.height = `${contentHeight + 40}px`; // Add a small buffer
    } else {
      // Map frontend enum to Playwright formats
      const formats = {
        'a4': 'A4',
        'a3': 'A3',
        'a5': 'A5',
        'letter': 'Letter',
        'legal': 'Legal',
        'executive': 'Executive',
        'tabloid': 'Tabloid'
      };
      pdfOptions.format = formats[paperSize] || 'A4';
    }

    const pdfBuffer = await page.pdf(pdfOptions);

    res.contentType('application/pdf');
    res.send(pdfBuffer);
  } catch (error) {
    console.error('PDF Generation Error:', error);
    res.status(500).send(`Failed to generate PDF: ${error.message}`);
  } finally {
    if (browser) {
      await browser.close();
    }
  }
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});
