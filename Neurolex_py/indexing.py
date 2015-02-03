from collections import defaultdict

def build_index():
    f_index=open("/home/neuromine/Neurolex_py/indexing_file")
    index=f_index.read()
    index=index.split("\n")
    dict_index={}
    for i in index[:-1]:
        i=i.split(",")
        dict_index[i[0]]=i[1]
        
    return dict_index
