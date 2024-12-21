# ------------------- Stage 1: Install Dependencies ---------------------
FROM python:3.9 AS dependencies

# Set the working directory to /dependencies
WORKDIR /dependencies

# Copy the requirements file into the container
COPY backend/requirements.txt .

# Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt

# ------------------- Stage 2: Copy Application Files -------------------
FROM python:3.9 AS app-files

# Set the working directory to /app
WORKDIR /app

# Copy the application source code
COPY backend/ .

# Copy the installed dependencies from the dependencies stage
COPY --from=dependencies /usr/local/lib/python3.9/site-packages/ /usr/local/lib/python3.9/site-packages/

# ------------------- Stage 3: Run the Application ----------------------
FROM python:3.9-slim

# Set the working directory to /app
WORKDIR /app

# Copy the application code and dependencies from the app-files stage
COPY --from=app-files /app /app
COPY --from=dependencies /usr/local/lib/python3.9/site-packages/ /usr/local/lib/python3.9/site-packages/

# Expose port 5000 for the application
EXPOSE 5000

# Define the default command to run the application
CMD ["python", "app.py"]
