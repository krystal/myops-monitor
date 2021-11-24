FROM ruby:3.0.2-slim-bullseye
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  build-essential \
  && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /root/.bundle \
  && useradd -d /opt/myops -m -s /bin/bash -u 1000 myops \
  && mkdir -p /opt/myops/app \
  && chown -R myops:myops /opt/myops
WORKDIR /opt/myops/app
RUN gem install bundler -v 2.2.29 --no-doc
COPY --chown=myops:myops Gemfile Gemfile.lock ./
RUN bundle install -j 4
COPY --chown=myops:myops . .
CMD ["bin/myops-monitor", "run"]
