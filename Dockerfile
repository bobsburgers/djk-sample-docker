FROM python:3.9-buster as base

FROM gitlab/gitlab-runner:alpine as the-files
RUN mkdir /install
WORKDIR /install
RUN git clone https://github.com/Dmitri-Sintsov/djk-sample.git

FROM base as builder
RUN mkdir /install
WORKDIR /install
ARG requirements=requirements.txt
ARG requirements_theme=bs4.txt
COPY --from=the-files /install/djk-sample/$requirements /install
COPY --from=the-files /install/djk-sample/requirements/$requirements_theme /install
RUN pip install --prefix=/install -r $requirements
RUN pip install --prefix=/install -r $requirements_theme

FROM base
COPY --from=builder /install /usr/local
COPY --from=the-files /install/djk-sample /opt/django-project
WORKDIR /opt/django-project
RUN mkdir -p logs
RUN mkdir -p statics
EXPOSE 8001
ADD docker-entrypoint.sh ./docker-entrypoint.sh
RUN chmod a+x ./docker-entrypoint.sh
ENTRYPOINT ["./docker-entrypoint.sh"]
