# Use the official Microsoft Playwright image with Ubuntu 24.04 (Noble) as requested
FROM mcr.microsoft.com/playwright:v1.59.1-noble

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json ./
# Playwright is already installed in the base image, but we need Express and the npm package
RUN npm install

# Copy application source code
COPY index.js ./

# Cloud Run Gen 2 uses the PORT environment variable (default 8080)
ENV PORT=8080
EXPOSE 8080

# Start the application
CMD ["npm", "start"]
