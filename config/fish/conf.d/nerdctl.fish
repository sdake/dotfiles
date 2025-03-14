set --export CONTAINERD_SNAPSHOTTER "stargz"
set --export BUILDKIT_HOST "unix:///$XDG_RUNTIME_DIR/buildkit/buildkitd.sock"
# set --export $CONTAINERD_ADDRESS "unix:///..."
# ctr --address /run/user/1002/containerd/containerd.sock images rm ..
