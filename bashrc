# Git

# install lazygit in your environment, it is a cli tool to make it easier to manage git repos
alias lzg="lazygit"

alias Ga='git add'
alias Gc='git commit'
alias Gck='git checkout'
alias Gckf='git checkout -f'
alias Gckb='git checkout -b'

Gfresh() {
	REMOTE=${1:-origin}
	BRANCH=$(git branch | grep \* | awk '{print $2}')
	TRUNK=${2:-develop}
	echo "Current: $BRANCH"
	echo "Trunk  : $REMOTE/$TRUNK"
	git checkout $TRUNK
	git fetch $REMOTE $TRUNK
	git reset --hard $REMOTE/$TRUNK
	git checkout $BRANCH
	git merge $TRUNK
}

Gsync() {
	REMOTE=${1:-origin}
	current_branch=$(git branch | grep \* | awk '{print $2}')
	BRANCH=${2:-$current_branch}
	echo "Syncing: ${REMOTE}/${BRANCH}"
	git checkout $BRANCH
	git fetch $REMOTE
	git reset --hard $REMOTE/$BRANCH
}

Gpu_() { # push and set upstream to same name
	git push --set-upstream $@ origin $(git branch | grep \* | cut -c3-)
}

Gacpu_() {
	if [ -n "$1" ]; then
		git add . && git commit -m "$1" && git push --set-upstream origin $(git branch | grep \* | cut -c3-)
	else
		git add . && git commit -m "x" && git push --set-upstream origin $(git branch | grep \* | cut -c3-)
	fi
}

# Docker
daci() {
	none_images=$(docker images -a | grep "<none>" | awk '{print $3}')
	if [ -z "$none_images" ]; then
		echo "Nothing to clean"
	else
		docker rmi $none_images
	fi
}

dres() {
	docker start $(docker ps -a | grep $1 | awk -F '   +' '{print $1}')
}

dsa() {
	docker stop $(docker ps -q)
}

dk() {
	REPOROOT=$(git rev-parse --show-toplevel)
	FOLDER=actions
	if [ -d cicd ]; then
		FOLDER=cicd
	fi
	([ ! -z "$REPOROOT" ] && source $REPOROOT/$FOLDER/bashrc 2>/dev/null && $@)
}

dg() {
	docker ps | grep $1 | awk '{print $1}'
}

dps() {
	docker ps --format '{{.ID}}\t{{.Status}}\t{{.Names}}\t{{.Ports}}'
}

dat() {
	CMD=${2:-bash}
	docker exec -it $(dg $1) $CMD
}

dsh() {
	docker run --rm -it -v /tmp:/tmp -v /var/run/docker.sock:/var/run/docker.sock -v $PWD:/app --workdir /app --network host $@
}

dlf() {
	docker logs -f $(dg $1)
}

dre() {
	docker restart $(dg $1)
}
