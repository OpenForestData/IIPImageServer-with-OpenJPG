# IIPImageServer with OpenJPG
External service required for the [Tiff Downloader](https://github.com/OpenForestData/TIFF-Downloader) (External Tool Backend for Dataverse) stack to work, heavily based on https://github.com/bodleian/iipsrv-openjpeg-docker.

## Installation

### Requirements
Docker (https://www.docker.com/) is required to build and run the application.
 
### Service external dependencies
- IIPImageServer ➤ https://iipimage.sourceforge.io/documentation/server/  
- OpenJPG ➤ https://www.openjpeg.org/  
- Apache Server ➤ https://httpd.apache.org/

### Application installation (local)

All you need is just build docker container with command:
```
docker build .
```
Or just download prebuild container:
```
docker pull registry.gitlab.whiteaster.com/openforestdata/backend/iipimageserver-with-openjpg:master
```

## Deployment

## Contribution
The project was performed by Whiteaster sp.z o.o., with register office in Chorzów, Poland - www.whiteaster.com and provided under the GNU GPL v.3 license to the Contracting Entity - Mammal Research Institute Polish Academy of Science in Białowieża, Poland.We are proud to release this project under an Open Source license. If you want to share your comments, impressions or simply contact us, please write to the following e-mail address: info@whiteaster.com