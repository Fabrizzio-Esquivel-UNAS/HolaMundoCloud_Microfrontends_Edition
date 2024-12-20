# Build Stage: Use Node.js to build the React application
FROM node:18-alpine AS build

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json files
COPY package*.json ./

# Install dependencies
RUN yarn install

# Copy the rest of the application files
COPY . .

# Build the React application
RUN yarn build

# Serve Stage: Use Nginx to serve the React build
FROM nginx:latest

# Copy the React build files to Nginx's default HTML directory
COPY --from=build /usr/src/app/build /usr/share/nginx/html

# Expose Nginx port
EXPOSE 3000

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]