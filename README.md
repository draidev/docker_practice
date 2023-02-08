# Docker_practice

노션 정리  
https://splendid-letter-5a5.notion.site/Docker-005ccbde6d804fdeb2b785a009f6f0cf  
<br>

### Dockerfile 이란?  
  DockerFile 은 코드의 형태로 인프라(도커 이미지)를 구성하는 방법을 텍스트 형식으로 저장해 놓은 파일이며 docker build 를 사용하여 자신만의 이미지를 만들 수 있다.
즉, 컨테이너 이미지를 build할 수 있는 명령어들의 집합  
<br>   

### docker compose 란?
  docker compose는여러 개의 컨테이너로 이루어진 서비스를 구축, 실행하는 순서를 자동으로하여 관리를 용이하게 하는 기능이다.   
<br>   

**주의 할 점**    
  Linux환경에서 ```docker compose up``` 명령어를 통해서 container terminal로 들어간 후 ```ctrl + c``` 를 통해 나오게 되면  데몬으로 실행중인 모든 container 가 동작을 멈추게 된다(Exited).   
  만약 ```-d``` 옵션을 주지않고 ```docker compose``` 명령어를 실행하였다면 동작중인 container가 STOP되지 않게 ```ctrl + z```명령어로 빠져나와야 한다.   
  원인은 docker compose 프로세스를 통해 container를 실행시킬 경우 전체 컨테이너 관리를 docker compose 프로세스가 맡아서 하여 종료 signal을 보냈을때 모든 container에 영향을 끼치는 것으로 보인다.
