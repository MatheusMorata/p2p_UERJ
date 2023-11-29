#!/bin/bash

# clean folder
rm -rf /tmp/freechains

# pubpvt keys from pioneer
PIONEIRO_PUBKEY=ADB56B48005452626DA84219DF000A2F92F63DC533D76BE0B806C4CF84A422F8
PIONEIRO_PVTKEY=CBBA777B93E03459033D97E249C65DB43547A644D52885C727E42A5B386B4212ADB56B48005452626DA84219DF000A2F92F63DC533D76BE0B806C4CF84A422F8

# pubpvt keys from users
ATIVO_PUBKEY=F055BD53EED18E6B964629D063DE722095C30EC7B002E245497D5332AD03C464
ATIVO_PVTKEY=57F3AFDEBA300207F6790C0BBA1FBEFA1AF8D42E0F6B8806B6D33D61F8F91AC7F055BD53EED18E6B964629D063DE722095C30EC7B002E245497D5332AD03C464

TROLL_PUBKEY=9ECFFB7E407E816FFD1CC90287F749817CCBB3B444598B226CBF0AD26743EA3E
TROLL_PVTKEY=84B2FCDB05906FE04F140608640834EFE56B676EC57EC88F4287D6AFA8165B509ECFFB7E407E816FFD1CC90287F749817CCBB3B444598B226CBF0AD26743EA3E

NOVATO_PUBKEY=A88DEEE7BB0AA7DD164CC71261E7B11B83178C6CD2ED9D610D75146DB689A8A1
NOVATO_PVTKEY=673E7C02F403692A9128D04B9295732D8DA5ED17494FB5FDB62C98B314E290F0A88DEEE7BB0AA7DD164CC71261E7B11B83178C6CD2ED9D610D75146DB689A8A1

# const variables
NUMBER_HOSTS=3
PUBLIC_FORUM_NAME="#futebol"
PIONEIRO_HOST=9001
ATIVO_HOST=9002
TROLL_HOST=9003
NOVATO_HOST=9001

updateHostsTimestamp() {
    NEW_DATE=`date -d "$DATE + $1 day" +%s`
    echo "Atualizando tempo"
    for (( host_idx = 1; host_idx <= $NUMBER_HOSTS; host_idx++ ))
    do
        freechains-host now $NEW_DATE --port=900$host_idx
    done
    echo "Tempo atualizado"
}

synchronizeHosts() {
    echo "Sincronizando..."
    for (( host_idx = 1; host_idx <= $NUMBER_HOSTS; host_idx++ ))
    do
        for (( host_idx_another = host_idx + 1; host_idx_another <= $NUMBER_HOSTS; host_idx_another++ ))
        do
            freechains --host=localhost:900$host_idx peer localhost:900$host_idx_another recv $PUBLIC_FORUM_NAME
            freechains --host=localhost:900$host_idx_another peer localhost:900$host_idx recv $PUBLIC_FORUM_NAME
        done
    done
    echo "Sincronizacao concluida"
}


getUserReps() {
    local user_pubkey=$1
    echo `freechains --host=localhost:9001 chain $PUBLIC_FORUM_NAME reps $user_pubkey`
}

getPostReps() {
    echo `freechains --host=localhost:9001 chain $PUBLIC_FORUM_NAME reps $1`
}

showAllUserReps() {
    echo "Reputacao do pioneiro: "
    getUserReps $PIONEIRO_PUBKEY
    echo "Reputacao do ativo: "
    getUserReps $ATIVO_PUBKEY
    echo "Reputacao do troll: "
    getUserReps $TROLL_PUBKEY
    echo "Reputacao do novato: "
    getUserReps $NOVATO_PUBKEY
}

giveLikeOrDislikeToPost() {
    if [ $1 = 0 ]; then
        if [ $( getPioneerReps ) -gt 1 ]; then
            freechains chain $PUBLIC_FORUM_NAME --port=$2 like $3 --sign=$PIONEIRO_PVTKEY
        fi

        if [ $( getActiveReps ) -gt 18 ]; then
            freechains chain $PUBLIC_FORUM_NAME --port=$2 like $3 --sign=$ATIVO_PVTKEY
        fi

        if [ $( getNewbieReps ) -gt 20 ]; then
            freechains chain $PUBLIC_FORUM_NAME --port=$2 like $3 --sign=$NOVATO_PVTKEY
        fi
    elif [ $1 = 2 ]; then
        if [ $( getPioneerReps ) -gt 5]; then
            freechains chain $PUBLIC_FORUM_NAME --port=$2 dislike $3 --sign=$PIONEIRO_PVTKEY
        fi

        if [ $( getActiveReps ) -gt 18 ]; then
            freechains chain $PUBLIC_FORUM_NAME --port=$2 dislike $3 --sign=$ATIVO_PVTKEY
        fi

        if [ $( getNewbieReps ) -gt 20 ]; then
            freechains chain $PUBLIC_FORUM_NAME --port=$2 dislike $3 --sign=$NOVATO_PVTKEY
        fi
    fi
}

echo "GENESIS DO FORUM FUTEBOL"
for (( host_idx = 1; host_idx <= $NUMBER_HOSTS; host_idx++ ))
do
    gnome-terminal -- freechains-host --port=900$host_idx start /tmp/freechains/host0$host_idx
    sleep 1
    freechains --host=localhost:900$host_idx chains join '#forum' $PIONEIRO_PUBKEY
    echo "Host0$host_idx OK..."
done

# Mensagens
PIONEER_MESSAGES=(
    "freechains --host=localhost:${PIONEIRO_HOST} chain '${PUBLIC_FORUM_NAME}' post inline 'Gol do Vasco' --sign=${PIONEIRO_PVTKEY}"
    "freechains --host=localhost:${PIONEIRO_HOST} chain '${PUBLIC_FORUM_NAME}' post inline 'Bom dia' --sign=${PIONEIRO_PVTKEY}"
    "freechains --host=localhost:${PIONEIRO_HOST} chain '${PUBLIC_FORUM_NAME}' post inline 'Gol do flamengo' --sign=${PIONEIRO_PVTKEY}"
)

ACTIVE_MESSAGES=(
    "freechains --host=localhost:${ATIVO_HOST} chain '${PUBLIC_FORUM_NAME}' post inline 'Eu adoro o Vasco da Gama' --sign=${ATIVO_PVTKEY}"
    "freechains --host=localhost:${ATIVO_HOST} chain '${PUBLIC_FORUM_NAME}' post inline 'Bom dia' --sign=${ATIVO_PVTKEY}"
    "freechains --host=localhost:${ATIVO_HOST} chain '${PUBLIC_FORUM_NAME}' post inline 'Eu odeio o Flamengo' --sign=${ATIVO_PVTKEY}"
)

TROLL_MESSAGES=(
    "freechains --host=localhost:${TROLL_HOST} chain '${PUBLIC_FORUM_NAME}' post inline 'Flamengo e melhor time do mundo' --sign=${TROLL_PVTKEY}"
    "freechains --host=localhost:${TROLL_HOST} chain '${PUBLIC_FORUM_NAME}' post inline 'Bom dia' --sign=${TROLL_PVTKEY}"
    "freechains --host=localhost:${TROLL_HOST} chain '${PUBLIC_FORUM_NAME}' post inline 'Gol do Flamengo' --sign=${TROLL_PVTKEY}"
)

NEWBIE_MESSAGES=(
    "freechains --host=localhost:${NOVATO_HOST} chain '${PUBLIC_FORUM_NAME}' post inline 'Nem vi o jogo' --sign=${NOVATO_PVTKEY}"
    "freechains --host=localhost:${NOVATO_HOST} chain '${PUBLIC_FORUM_NAME}' post inline 'Bom dia' --sign=${NOVATO_PVTKEY}"
    "freechains --host=localhost:${NOVATO_HOST} chain '${PUBLIC_FORUM_NAME}' post inline 'Quanto foi o jogo' --sign=${NOVATO_PVTKEY}"
)

echo "Comecando"
for (( i = 1; i <= 90; i++ ))
do
    echo "Day $i"
    updateHostsTimestamp $i
    synchronizeHosts

    MESSAGE_RANDOM_NUMBER=`shuf -i 0-1 -n 1`

    # Pioneiro posta a cada 1 dia
    if [ $(($i % 1)) = 0 ]; then
        HASH_MESSAGE=$(eval ${PIONEER_MESSAGES[$MESSAGE_RANDOM_NUMBER]})
        giveLikeOrDislikeToPost $MESSAGE_RANDOM_NUMBER $PIONEIRO_HOST $HASH_MESSAGE
    fi

    # Ativo posta a cada 2 dias
    if [ $(($i % 2)) = 0 ]; then
        HASH_MESSAGE=$(eval ${ACTIVE_MESSAGES[$MESSAGE_RANDOM_NUMBER]})
        giveLikeOrDislikeToPost $MESSAGE_RANDOM_NUMBER $ATIVO_HOST $HASH_MESSAGE
    fi

    # Troll posta a cada 2 dias
    if [ $(($i % 2)) = 0 ]; then
        MESSAGE_RANDOM_NUMBER=2 
        HASH_MESSAGE=$(eval ${TROLL_MESSAGES[$MESSAGE_RANDOM_NUMBER]})
        giveLikeOrDislikeToPost $MESSAGE_RANDOM_NUMBER $TROLL_HOST $HASH_MESSAGE
    fi

    # Novato posta a cada 1 dia
    if [ $(($i % 6)) = 0 ]; then
        HASH_MESSAGE=$(eval ${NEWBIE_MESSAGES[$MESSAGE_RANDOM_NUMBER]})
        giveLikeOrDislikeToPost $MESSAGE_RANDOM_NUMBER $NOVATO_HOST $HASH_MESSAGE
    fi

    showAllUserReps
done

echo "FIM"