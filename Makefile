build:
	docker buildx build --platform linux/amd64,linux/arm64 -t nehiyr/php:8.2-fpm --push .
