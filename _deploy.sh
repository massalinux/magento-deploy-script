
#!/bin/bash
upgrade=true
compile=true
static=true
reindex=false
prefix=""

if [ "$1" = "staticonly" ]
then
    echo "Lancio deploy in modalità light (solo file statici)"
    upgrade=false
    compile=false
elif [ "$1" = "nostatic" ]
then
    echo "Lancio deploy in modalità no static (update, compile)"
    reindex=false
    static=false
elif [ "$1" = "full" ]
then
    echo "Lancio deploy in modalità full"
    reindex=true
else
   echo "Lancio deploy in modalità default (update, compile, static)"
fi


rm -fr $prefixvar/log/*
rm -fr $prefixvar/cache/*
rm -rf $prefixvar/view_preprocessed/*
rm -fr $prefixgenerated/code/*
rm -fr $prefixgenerated/metadata/*

if [ "$upgrade" = true ]
then
bin/magento setup:upgrade
fi

if [ "$compile" = true ]
then
bin/magento setup:di:compile
fi

if [ "$static" = true ]
then
rm -rf $prefixpub/static/*
bin/magento setup:static-content:deploy -f it_IT
fi

if [ "$reindex" = true ]
then
bin/magento indexer:reset
bin/magento indexer:reindex
fi

bin/magento cache:flush
