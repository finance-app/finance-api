FROM phusion/passenger-ruby26:latest
ENV HOME /root
CMD ["/sbin/my_init"]

# Install tzdata so gem does not need to be installed.
RUN apt-get update && apt-get install -y tzdata

# Upgrade bundler to latest version.
RUN gem install bundler

# Enable and configure nginx.
RUN rm -f /etc/service/nginx/down

COPY ./docker/nginx.conf /etc/nginx/sites-enabled/default

# Copy init script, which injects environment variables into nginx configuration.
COPY ./docker/init.sh /etc/my_init.d/

# Disable nginx-log-forwarder because we just use stderr/stdout, but
# need to remove the "sv restart" line in the nginx run command too.
RUN touch /etc/service/nginx-log-forwarder/down && \
    sed -i '/nginx-log-forwarder/d' /etc/service/nginx/run

# Forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
		ln -sf /dev/stderr /var/log/nginx/error.log && \
    mkdir -p /home/app/log && \
		ln -sf /dev/stdout /home/app/log/production.log

WORKDIR /home/app

# Copy Gemfile and install dependencies.
COPY --chown=app:app Gemfile Gemfile.lock /home/app/

RUN su app -c /bin/bash -c "cd /home/app && bundle config set deployment 'true' && bundle install"

# Copy rest of the source code.
COPY --chown=app:app . /home/app

# Cleanup to reduce container size.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
