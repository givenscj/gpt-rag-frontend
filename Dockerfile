# Use the latest LTS version of Node.js
FROM node:18-alpine

RUN apk add g++ make python3 py3-pip git
 
# Set the working directory inside the container
WORKDIR /temp
 
# Copy the rest of your application files
COPY frontend/ .

# Install dependencies
RUN npm install
RUN npm run build

RUN python3 -m venv ~/pyvenv --system-site-packages
RUN . ~/pyvenv/bin/activate
RUN pip install --upgrade pip --break-system-packages

WORKDIR /app

RUN cp -r /backend /app

COPY backend/ .

RUN pip install -r requirements.txt --break-system-packages
 
# Expose the port your app runs on
EXPOSE 8000
 
# Define the command to run your app
CMD ["python3", "app.py"]