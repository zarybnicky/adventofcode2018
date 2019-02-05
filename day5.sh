#!/usr/bin/env bash

read -r LINE < ./day5.txt
LINE_ORIG="$LINE"
N=0

reduce() {
    while
        LINE2=$(echo "$LINE" | sed 's/aA\|Aa\|bB\|Bb\|cC\|Cc\|dD\|Dd\|eE\|Ee\|fF\|Ff\|gG\|Gg\|hH\|Hh\|iI\|Ii\|jJ\|Jj\|kK\|Kk\|lL\|Ll\|mM\|Mm\|nN\|Nn\|oO\|Oo\|pP\|Pp\|qQ\|Qq\|rR\|Rr\|sS\|Ss\|tT\|Tt\|uU\|Uu\|vV\|Vv\|wW\|Ww\|xX\|Xx\|yY\|Yy\|zZ\|Zz//g')
        [ "$LINE" != "$LINE2" ]
    do
        LINE="$LINE2"
    done
    N=$(($(echo "$LINE" | wc -c) - 1))
}

echo -n 'Entire string: '
echo -n $(($(echo "$LINE_ORIG" | wc -c) - 1))
LINE="$LINE_ORIG"
reduce
echo " -> $N"

LENGTHS=()
PAIRS="aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ"
for PAIR in $PAIRS; do
    echo -n "Replacing $PAIR: "
    LINE=$(echo "$LINE_ORIG" | sed -E "s/[$PAIR]//g")
    echo -n $(($(echo "$LINE" | wc -c) - 1))
    reduce
    echo " -> $N"
    LENGTHS+=("$N")
done

MIN=${LENGTHS[0]}
for I in "${LENGTHS[@]}"; do
  (( I < MIN )) && MIN=$I
done
echo "Minimum: $MIN"
