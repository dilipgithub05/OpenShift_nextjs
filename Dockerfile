# Use an official Node.js runtime as a parent image
FROM node:18 AS builder

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock) into the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code into the container
COPY . .

# Build the Next.js application
RUN npm run build

# Use a smaller image for the production environment
FROM node:18-slim

# Set the working directory in the container
WORKDIR /app

# Copy the build output and necessary files from the builder stage
COPY --from=builder /app ./

# Install only production dependencies
RUN npm install --only=production

# Install additional tools for QA (e.g., testing libraries)
RUN npm install --save-dev jest supertest

# Expose the port on which the app will run
EXPOSE 3000

# Start the Next.js application
CMD ["npm", "run", "dev"]
