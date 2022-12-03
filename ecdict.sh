#!/bin/sh
if [ ! -d "ECDICT" ] 
then
    git clone https://github.com/skywind3000/ECDICT
fi

python3 -c "from ECDICT import stardict; stardict.convert_dict('ecdict.csv', 'ecdict.db')"
zip ecdict.db.zip ecdict.db