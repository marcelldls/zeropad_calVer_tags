# Substitution based on: https://regex101.com/r/jrLpp2/1
match="(?<=\.)([1-9])(?=(\.|$))"
sub="0\1"

if [ "$1" == "--preview" ]
then
    echo "Preview changed tags:"
    git tag -l | while read t
    do
        n=$(python -c "import re; print(re.sub(r'$match', r'$sub', '$t'))")
        echo "$t -> $n"
    done

elif [ "$1" == "--local" ]
then
    git tag -l | while read t;
    do
        n=$(python -c "import re; print(re.sub(r'$match', r'$sub', '$t'))")
        git tag $n $t && git tag -d $t
    done

elif [ "$1" == "--push" ]
then
    git tag -l | while read t;
    do
        n=$(python -c "import re; print(re.sub(r'$match', r'$sub', '$t'))")
        git tag $n $t && git push --tags && git tag -d $t && git push origin :refs/tags/$t
    done
else
    echo "No argument given: Enter either --preview, --local or --push"
fi
