# Docker_practice

노션 정리  
https://splendid-letter-5a5.notion.site/Docker-005ccbde6d804fdeb2b785a009f6f0cf  
<br>

## Docker Image   
  도커에서 서비스 운영에 필요한 서버 프로그램, 소스코드 및 라이브러리, 컴파일된 실행 파일을 묶는 형태를 Docker Image라한다. 다시 말해, 특정 프로세스를 실행하기 위한(즉, 컨테이너 생성(실행)에 필요한) 모든 파일과 설정값(환경)을 지닌 것으로, 더 이상의 의존성 파일을 컴파일하거나 이것저것 설치할 필요 없는 상태의 파일을 의미한다.
<br>   
## Docker Container
이미지(Image)를 실행한 상태로, 응용프로그램의 종속성과 함께 응용프로그램 자체를 패키징 or 캡슐화하여 격리된 공간에서 프로세스를 동작시키는 기술이다.   


## docker configure
**daemon.json**
- 경로 : /etc/docker/daemon.json   

### 도커 이미지 배포할때 설정파일이 볼륨으로 잡혀있는 경우 최신 conf파일로 업데이트 되지 않는 문제   
- 새로운 버전의 docker image로 update했을때 container를 up하면 기존의 호스트 conf경로 volume을 바라봄    
	- 따라서 이전 버전의 conf를 보고있음   
- 이럴 경우 docker 컨테이너를 Created 상태로 띄어 놓고 container내의 conf파일을 docker cp 명령어로 host conf경로에 복사한 뒤 컨테이너를 띄우면 바뀐 설정파일을 바라본다.   
```docker cp $(docker create [이미지 이름] -name [컨테이너 이름]):[컨테이너 conf 파일 경로] [host conf 파일 경로]```   



## Dockerfile 이란?
  DockerFile 은 코드의 형태로 인프라(도커 이미지)를 구성하는 방법을 텍스트 형식으로 저장해 놓은 파일이며 docker build 를 사용하여 자신만의 이미지를 만들 수 있다.
즉, 컨테이너 이미지를 build할 수 있는 명령어들의 집합  
<br>   

## docker compose 란?
  docker compose는여러 개의 컨테이너로 이루어진 서비스를 구축, 실행하는 순서를 자동으로하여 관리를 용이하게 하는 기능이다.   
<br>   

**주의 할 점**    
  Linux환경에서 ```docker compose up``` 명령어를 통해서 container terminal로 들어간 후 ```ctrl + c``` 를 통해 나오게 되면  데몬으로 실행중인 모든 container 가 동작을 멈추게 된다(Exited).   
  만약 ```-d``` 옵션을 주지않고 ```docker compose``` 명령어를 실행하였다면 동작중인 container가 STOP되지 않게 ```ctrl + z```명령어로 빠져나와야 한다.   
  원인은 docker compose 프로세스를 통해 container를 실행시킬 경우 전체 컨테이너 관리를 docker compose 프로세스가 맡아서 하여 종료 signal을 보냈을때 모든 container에 영향을 끼치는 것으로 보인다.   

### GPU를 사용할 때 
**docker-compose.yml**에 다음과 같이 deploy옵션 추가   
```
deploy:
  resources:
    reservations:
      devices:
      - driver: nvidia
        count: all
        capabilities: [gpu]
```   

**daemon.json**
```
{
    "data-root": "/data/docker_repo",
    "storage-driver": "overlay2",
    "default-runtime": "nvidia",
    "runtimes": {
        "nvidia": {
            "path": "nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
```

### docker compose ls   
Docker Compose 파일에 정의된 모든 서비스를 나열하는 데 사용됩니다. 서비스 이름, 서비스를 시작하는 데 사용된 명령 및 노출된 포트와 같은 정보를 표시합니다. 이 명령은 Compose 파일에 정의된 모든 서비스의 상태를 확인하는 데 유용합니다. 실제로 일부 서비스가 실행되고 있지 않더라도 모든 서비스를 나열할 수 있습니다.   
- 전체 Docker Compose 프로젝트에 대한 이름을 지정하기 위해서는 ```-p``` 또는 ```--project-name``` 옵션을 ```docker-compose``` 명령어와 함께 사용해야 합니다.   
- 이는 ```docker-compose.yml```파일의 ‘services’위에 ‘name’옵션을 사용하는 것과 동일합니다.   
```
version: "3.9"

name: project-name

services:
  sndr_0:
    image: "sample:image"
    restart: always
    hostname: root
    container_name: sample
    deploy:
      resources:
        limits:
          memory: 150G
```   

<br>

### docker container 내에서 systemd 활용하기   
기본적으로 Docker는 운영 체제의 프로세스 관리자(systemd, upstart 등)를 지원하지 않는다. 그러나 일부 컨테이너 OS 이미지(예: Ubuntu)는 systemd를 포함하고 있으며, 이러한 이미지에서는 systemd를 사용할 수 있다.   

systemd를 사용하려면 다음과 같은 조치가 필요하다.    

1. Dockerfile에서 이미지를 빌드할 때 systemd 패키지를 설치해야한다.     
```
RUN apt-get update && apt-get install -y systemd   
```   

2. systemd를 시작하려면 컨테이너를 실행할 때 다음과 같은 옵션을 추가해야한다.
```
docker run -it --rm --privileged --pid=host <image-name>
```   
```--rm``` : 컨테이너를 일회성으로 실행할 때 주로 쓰인다. 컨테이너가 종료될 때 컨테이너와 관련된 리소스(파일 시스템, 볼륨)까지 깨끗이 제거해준다.   
```--privileged``` : 컨테이너가 호스트의 모든 기능에 액세스 할 수 있도록 한다.   
```--pid=host``` : 컨테이너에서 호스트의 프로세스 트리를 볼 수 있도록 한다.   

이후에 systemd를 시작하고 서비스를 관리 할 수 있다. 하지만 이렇게 **systemd를 사용하는 것은 보안상의 이유로 권장되지 않는다**.  컨테이너에 대한 운영 체제 관리 작업은 가능한한 수행하지 않는 것이 좋다. 대신에 Docker의 컨테이너 관리 기능을 사용하는 것이 좋다.   
<br>

**주의**   
docker container내에서 systemd로 프로세스를 실행시킬 경우 Dockerfile에서 설정한 ENV 환경변수 설정을 적용하지 않는 문제가 있다.   
따라서 이러한 문제가 발생할경우 해당 프로세스의 코드에 직접 경로를 설정해주는 작업을 해야할 수 있다.
