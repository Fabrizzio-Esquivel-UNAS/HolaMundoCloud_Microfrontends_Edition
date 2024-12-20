# Use an official Node.js runtime as the base image
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json files to the working directory
COPY package*.json ./

# Install Node.js dependencies
RUN yarn install

# Copy the rest of the application files to the working directory
COPY . .

# Expose the port your app will run on
EXPOSE 3030

# Command to run the application
CMD ["yarn", "start"]