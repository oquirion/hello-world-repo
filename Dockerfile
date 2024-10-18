# Step 1: Use an official Node.js image as the base
FROM node:18-alpine AS build

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy package.json and package-lock.json (if available) to the container
COPY package*.json ./

# Step 4: Install dependencies
RUN npm install

# Step 5: Copy the rest of your application's source code to the container
COPY . .

# Step 6: Compile TypeScript to JavaScript
RUN npm run build

# Step 7: Use a smaller Node.js runtime image to run the application
FROM node:18-alpine

# Step 8: Set the working directory in the new image
WORKDIR /app

# Step 9: Copy the compiled output and node_modules from the build stage
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package*.json ./

# Step 10: Expose the port your application runs on
EXPOSE 3000

# Step 11: Define the command to run your application
CMD ["node", "index.js"]