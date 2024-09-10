import boto3
import pymongo
import json
import os
from bson.json_util import dumps
from botocore.exceptions import NoCredentialsError, PartialCredentialsError

# Configuration
MONGO_URI = 'mongodb://xxx:xxx@xxx:27017/'  # MongoDB connection string
DATABASE_NAME = ''
COLLECTION_NAME = ''
BACKUP_FILE = ''
BUCKET_NAME = ''
AWS_REGION = 'us-west-2'  # Change to your region

# Connect to MongoDB
def connect_mongo(uri):
    client = pymongo.MongoClient(uri)
    return client

# Backup MongoDB collection to a file
def backup_collection(db_name, collection_name, file_path):
    client = connect_mongo(MONGO_URI)
    db = client[db_name]
    collection = db[collection_name]

    with open(file_path, 'w') as file:
        cursor = collection.find({})
        file.write(dumps(cursor, indent=4))
    
    print(f"Backup complete: {file_path}")

# Create S3 bucket if it doesn't exist
def create_bucket_if_not_exists(bucket_name, region):
    s3_client = boto3.client('s3', region_name=region)
    
    try:
        s3_client.create_bucket(
            Bucket=bucket_name,
            CreateBucketConfiguration={
                'LocationConstraint': region
            }
        )
        print(f"Bucket created: {bucket_name}")
    except s3_client.exceptions.BucketAlreadyOwnedByYou:
        print(f"Bucket already exists: {bucket_name}")
    except s3_client.exceptions.BucketAlreadyExists:
        print(f"Bucket name already taken: {bucket_name}")
    except Exception as e:
        print(f"Error creating bucket: {e}")

# Upload file to S3 bucket
def upload_to_s3(file_path, bucket_name, region):
    s3_client = boto3.client('s3', region_name=region)
    
    try:
        s3_client.upload_file(file_path, bucket_name, os.path.basename(file_path))
        print(f"File uploaded to S3 bucket {bucket_name}")
    except FileNotFoundError:
        print(f"File not found: {file_path}")
    except NoCredentialsError:
        print("Credentials not available")
    except PartialCredentialsError:
        print("Incomplete credentials")
    except Exception as e:
        print(f"Error uploading file: {e}")

# Main function
def main():
    # Step 1: Backup MongoDB collection
    backup_collection(DATABASE_NAME, COLLECTION_NAME, BACKUP_FILE)
    
    # Step 2: Create S3 bucket if it doesn't exist
    create_bucket_if_not_exists(BUCKET_NAME, AWS_REGION)
    
    # Step 3: Upload backup file to S3
    upload_to_s3(BACKUP_FILE, BUCKET_NAME, AWS_REGION)
    
    # Cleanup
    os.remove(BACKUP_FILE)
    print(f"Local backup file removed: {BACKUP_FILE}")

if __name__ == "__main__":
    main()
