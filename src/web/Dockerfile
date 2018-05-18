FROM node:10.1.0

COPY . /home/node/web/
WORKDIR /home/node/web
RUN chown node --recursive .

USER node

CMD ["node", "app.js"]