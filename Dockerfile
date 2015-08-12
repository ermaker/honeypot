FROM ruby:onbuild

ENV WEB_CONCURRENCY=4
ENV RAILS_ENV=production

EXPOSE 5000
CMD ["foreman", "start"]
