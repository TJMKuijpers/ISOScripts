# GitHub CLI api 
# Get repositories for organization
# T.J.M. Kuijpers, March 2025, The Hyve
#
options=$(getopt -o pgmlkKicjhxe:dr:b --long org:,repos,users-in-repo:,output-file: -- "$@")
eval set -- "$options"
while true; do
        case "$1" in
        --org)
        ORGANIZATION=true
        shift
        ORG=$1
        ;;
        --repos) REPO=true
        ;;
        --users-in-repo) 
        USER_REPO=true
        shift
        REPO=$1
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
        if [[ "$REPO" = true ]]; then
           echo "looking for repos in the organization"
           gh api -H "Accept: application/vnd.github+json" \
                  -H "X-Github-Api-Version: 2022-11-28" \
                  /orgs/"$ORG"/repos | jq '[.[] | {name}]' > "$OUTPUT_FILE"
        fi
        if [[ "$USER_REPO" = true ]]; then
           echo "looking for members in the selected repo"  
           gh api -H "Accept: application/vnd.github+json" \
                  -H "X-GitHub-Api-Version: 2022-11-28" \
	          /repos/"$ORG"/"$REPO"/members >  "$OUTPUT_FILE"
        fi
fi

