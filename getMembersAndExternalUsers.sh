# Use Github API to get all members of organization
#
#  T.J.M. Kuijpers, March 2025, The Hyve
options=$(getopt -o pgmlkKicjhxe:dr:b --long org:,members,external,output-file: -- "$@")

eval set -- "$options"
while true; do
	case "$1" in 
        --org) 
	ORGANIZATION=true
        shift
	ORG=$1
	;;
	--external) EXTERNAL=true
	;;
	--members) MEMBERS=true
	;;
        --output-file)
	shift
        OUTPUT_FILE="$1"
        ;;	
	--) shift;break
	;;
        esac
        shift
done


if [[ "$ORGANIZATION" != true ]]; then
	echo "You need to provide an organization"
	exit 1
fi

if [[ "$ORGANIZATION" = true ]]; then
	if [[ "$EXTERNAL" = true ]]; then
           echo "looking for external collaborators"
           gh api -H "Accept: application/vnd.github+json" \
                  -H "X-Github-Api-Version: 2022-11-28" \
                  /orgs/"$ORG"/outside_collaborators > "$OUTPUT_FILE"

	fi
	if [[ "$MEMBERS" = true ]]; then
	   echo "looking for members of the organization"	   
	   gh api -H "Accept: application/vnd.github+json" \
                  -H "X-GitHub-Api-Version: 2022-11-28" \
                  /orgs/"$ORG"/members | jq '[.[] | {login,id,url,type}]' > "$OUTPUT_FILE"
	fi
fi

