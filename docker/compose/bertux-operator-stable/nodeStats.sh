docker-compose ps -q | parallel docker exec {} ./witnet node nodeStats
