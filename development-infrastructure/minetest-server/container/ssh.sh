ssh \
 -F /dev/null \
 -t \
 -o UserKnownHostsFile=/dev/null \
 -o StrictHostKeyChecking=no \
 -o IdentitiesOnly=yes \
 -o CheckHostIP=no \
 -o LogLevel=ERROR \
 -i ~/.ssh/id_rsa_minetest_server \
 davidbrandt@127.0.0.1 \
 -p 11002

