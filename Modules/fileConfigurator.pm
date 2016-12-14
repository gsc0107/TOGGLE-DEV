package fileConfigurator:

sub createFileConf
{
    #This subprogram will generate a config file for all soft tests.
}

sub softParams
{
    #This sub gathers all the soft parameters for tests
    
    my %testParams =    {   tgicl => ("-c 6","-p 90","-l 20"),
                            trinity => ("--seqType fq","--max_memory 20G","--full_cleanup"),
                        }
}

1;