#!/bin/bash

# Array para armazenar os convidados
guests=()

# Função para verificar se um convidado é especial
is_special() {
    local specialFlag="$1"
    if [ "$specialFlag" = "SIM" ]; then
        echo true
    else
        echo false
    fi
}

# Entrada da lista de convidados
read -p "Digite a lista de convidados no formato 'NOME-SOBRENOME-NUMERO-ESPECIAL=SIM, NOME-SOBRENOME-NUMERO,-ESPECIAL=NAO,ETC...': " guestList

# Separar os convidados
IFS=', ' read -r -a guestsArray <<< "$guestList"

# Loop para processar cada convidado
for guestEntry in "${guestsArray[@]}"; do
    firstName=$(echo "$guestEntry" | cut -d'-' -f1)
    lastName=$(echo "$guestEntry" | cut -d'-' -f2)
    number=$(echo "$guestEntry" | cut -d'-' -f3)
    specialFlag=$(echo "$guestEntry" | cut -d'=' -f2)
    isSpecial=$(is_special "$specialFlag")

    # Construir a string JSON do convidado
    if [ "$isSpecial" = true ]; then
        guest="{\"firstName\":\"$firstName\",\"lastName\":\"$lastName\",\"Number\":\"$number\",\"isSpecial\":true}"
    else
        guest="{\"firstName\":\"$firstName\",\"lastName\":\"$lastName\",\"Number\":\"$number\"}"
    fi

    # Adicionar o convidado ao array
    guests+=("$guest")
done

# Saída no arquivo JavaScript
echo "var convidados = $(echo "[" "${guests[@]}" "]");" > convidados.js

echo "Arquivo 'convidados.js' salvo no diretório local com sucesso."
