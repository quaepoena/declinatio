# -*- mode: Shell-script; -*-

function declinatio() {
    if [[ "$#" -lt 1 ]]; then
	echo "Usage: declinatio file [args]" >&2
	return 1
    fi

    local declinatio_file="$1"
    source "${declinatio_file}"

    if [[ "$?" -ne 0 ]]; then
	echo "Error while sourcing ${declinatio_file}. Exiting." >&2
	return 1
    fi

    shift

    if [[ "$#" -ne "${argument_count}" ]]; then
	echo "${usage}" >&2
	return 1
    fi

    run "$@"
}


function declinatio::array_contains() {
    local -r element="$1"
    local -ra array="$2"

    for i in ${array[@]}; do
	if [[ "${element}" == "${i}" ]]; then
	    return 0
	fi
    done

    return 1
}


declinatio::check_mt() {
    if [[ "$#" -ne 1 ]]; then
	echo "Must pass one argument to declinatio::check_mt." >&2
	return 1
    fi

    # Relevant for verbs like "atmen."
    if [[ "$1" =~ (.*m)(s{,1}t.*) ]]; then
	echo "${BASH_REMATCH[1]}e${BASH_REMATCH[2]}"
    else
	echo "$1"
    fi
}


function declinatio::print_passive() {
    local string="$1"
    local -r mask="$2"
    local -ar allowed="$3"

    if [[ "$#" -lt 3 ]]; then
    	echo "At least three arguments needed for print_passive()." >&2
    	return 1
    fi

    # Account for passives that don't allow animate subjects.
    if declinatio::array_contains "${mask}" "tjn tnn"; then
	string="$(echo "${string}" | sed 's_er/sie/es_es_')"
    fi

    if declinatio::array_contains "${mask}" "${allowed}"; then
	echo "${string}"
    else
	echo "-"
    fi

    return 0
}
