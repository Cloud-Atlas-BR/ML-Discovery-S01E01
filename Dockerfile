# Imagem Base
FROM python:3.8.8-slim-buster

# Criação do diretório padrão do lambda container
ARG FUNCTION_DIR="/function/"
WORKDIR ${FUNCTION_DIR}

# Treinamento do modelo

COPY requirements.txt ${FUNCTION_DIR}/requirements.txt
COPY train.py ${FUNCTION_DIR}/train.py

RUN pip3 install \
        --target ${FUNCTION_DIR} \
        -r requirements.txt

RUN python3 train.py

# Instalação do awslambdaric
RUN apt-get update && \
  apt-get install -y \
  g++ \
  make \
  cmake \
  unzip \
  wget \
  libcurl4-openssl-dev

RUN pip3 install --target ${FUNCTION_DIR} awslambdaric

# Obtenção do aws-lambda-rie
RUN wget https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie -P /usr/local/bin/
RUN chmod +x /usr/local/bin/aws-lambda-rie

# Cópia dos arquivos de execução
COPY app.py app.py
RUN chmod +x app.py

COPY entry.sh entry.sh
RUN chmod +x entry.sh

ENTRYPOINT [ "./entry.sh" ]
CMD [ "app.handler" ]