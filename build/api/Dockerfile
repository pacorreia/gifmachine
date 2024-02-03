FROM ruby:2.6.5-alpine3.11 as install_deps

RUN \
  apk add --update --no-cache \
    bash \
    build-base \
    curl \
    postgresql-client \
    postgresql-dev

FROM install_deps as install_rvm

  RUN  curl -L https://get.rvm.io | rvm_tar_command=tar bash -s stable

FROM install_rvm as install_app

WORKDIR /app/

COPY /Gemfile /Gemfile.lock /app/
RUN bundle install

COPY / /app

COPY build/api /app
RUN chmod +x /app/start.sh

EXPOSE 80

ENTRYPOINT [ "./start.sh" ]