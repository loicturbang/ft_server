# ft_server
42 project to install a complete web server using Docker. This server runs multiple services: Wordpress, phpMyAdmin and a SQL database.

## Final grade : 100/100

Mandatory part : 100/100

## How to run

Use this command to build an image from Dockerfile in current directory.

```
docker build -t myimage:1.0 .
```

Now run with :

```
docker run --name web -p 80:80 -p 443:443 myimage:1.0
```