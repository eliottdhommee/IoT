FROM node:latest

WORKDIR /app

COPY package.json /app

COPY yarn.lock /app

RUN yarn

COPY . /app

EXPOSE 3006

CMD ["yarn","run","dev"]!
