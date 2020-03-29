# Overview
The need of continous delivery enforces storing sensitive data is some place that is eaisily accessible by pipeline job.

One way of doing it is to store sensitive data at git repository in encrypted files. The git-secret may help you out. 

Before starting, it is good idea to take a look at the official documentation: https://git-secret.io and to learn basic concepts about adding/revoking GPG keys and encrypting/decrypting files.



# Setting up git-secret in a repository
Follow section `Setting up git-secret in a repository` from https://git-secret.io

# Building Docker image
```
docker build . -t git-secret:latest
```

# Integrating git-secret image with delivery pipeline

## Generating GPG key pair
Generate GPG key pair that will be used with your pipeline:
```
gpg --gen-key
```

## Obtaining GPG private key
Get GPG key in base64 format:
```
GPG_PRIVATE_KEY=$(gpg --export-secret-key --armour <key-id> |base64)
```
where `<key-id>` is an email provided while generating GPG key pair.

Store GPG private key in a secure way at your pipeline provider (e.g.: use KMS)

## Configuring pipeline
At the begining of your pipeline use this docker image to decrypt files. Provide environment variable `GPG_PRIVATE_KEY` that contains  key.

Make sure that your pipeline can access `git-secret:latest` Docker image.

## Example

The `examples/reveal/cloudbuild.yaml` file conteins a job that decrypts files from repository aby using GPG private key that us secured by Google KMS.

In order to learn more about KMS, follow: https://cloud.google.com/cloud-build/docs/securing-builds/use-encrypted-secrets-credentials


# Running locally
Go to repository with encrypted files and run below commands:
```
GPG_PRIVATE_KEY=$(gpg --export-secret-key --armour <key-id> |base64)
```
where `<key-id>` is an email provided while generating GPG key pair. 

Then decrypt files from your repository:


```
docker run  \
-v `pwd`:/app/repo \
-w /app/repo \
-e GPG_PRIVATE_KEY=$GPG_PRIVATE_KEY \
git-secret:latest \
reveal
```

# Troubleshooting
If you see error like below:
```
git-secret: abort: problem decrypting file with gpg: exit code 2: <path>
```
then most probably the `<path>` is a file that is already decrypted, thus an error.

