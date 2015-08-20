FROM ruby:onbuild

ENV WEB_CONCURRENCY=4
ENV RAILS_ENV=production

RUN rake assets:precompile assets:clean

EXPOSE 5000
CMD ["foreman", "start"]
