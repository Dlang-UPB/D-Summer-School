start:
	make -C ../docker start

attach-to-logs:
	make -C ../docker attach-to-logs

# This will stop and delete the containers
# Following this, make start will trigger a full rebuild
stop:
	make -C ../docker stop

# This is the nuclear option
# This will destroy all the containers and images
# Following this, make start will have to rebuild the images, then trigger a full rebuild
# Use with caution
.PHONY: clean
clean:
	make -C ../docker clean
