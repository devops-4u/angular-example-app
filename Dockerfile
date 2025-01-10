# Step 1: Use a Node.js image as the base image
FROM node:18 as build-stage

# Step 2: Set the working directory in the container
WORKDIR /app

# Step 3: Copy the application code into the container
COPY . .

# Step 4: Install dependencies
RUN npm install

# Step 5: Build the Angular application
RUN npm run build --prod


FROM nginx:alpine as serve-stage

COPY --from=build-stage /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
