### Base Image 지정    
FROM mariadb:10.4.18  

### TimeZone 환경 변수 지정
ENV TZ Asia/Seoul  

### Mariadb root 비밀번호 설정
ENV MYSQL_ROOT_PASSWORD=root

### Mariadb Database 생성  
ENV MYSQL_DATABASE=deverse      

### TimeZone 설정
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

### Mariadb User 및 DB 스키마 설정 스크립
ADD deverse.sql /docker-entrypoint-initdb.d/deverse.sql
ADD db_user.sql /docker-entrypoint-initdb.d/db_user.sql

### 홈 디렉토리
WORKDIR /home/dev

### 서비스 포트
EXPOSE 3306
