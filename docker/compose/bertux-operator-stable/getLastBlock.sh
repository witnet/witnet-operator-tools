docker-compose ps -q | parallel docker exec {} witnet node blockchain --epoch=-1 --limit=1
