# +
import sqlite3
import pandas
import glob
import os
import requests
from zipfile import ZipFile

DB_PATH = 'omop.db'
CDM_VERSION = '5.2.2'
DDL_PATH = 'omop_cdm_{v}_ddl.sql'.format(v=CDM_VERSION)
SYNPUF_URL = 'http://www.ltscomputingllc.com/wp-content/uploads/2018/08/synpuf1k_omop_cdm_{v}.zip'.format(v=CDM_VERSION)
CSV_SEP = '\t'

# remove database file if it exists
if os.path.exists(DB_PATH):
    os.remove(DB_PATH)

conn = sqlite3.connect(DB_PATH)

# + {"lines_to_next_cell": 2}
def read_text(p):
    """
    Get text from a file at specified path
    """
    with open(p, 'r') as fp:
        return fp.read()

def ls_csv(p):
    """
    Get list of csv files in specified dir
    """
    pattern = os.path.join(p, '*.csv')
    return glob.glob(pattern)

def cols(t):
    """
    Get list of columns in specified sqlite table
    """
    cur = conn.cursor()
    cur.execute("select * from {t} where 1=0".format(t=t))
    cur.fetchall()
    return list(map(lambda x: x[0], cur.description))

def load_csv(p):
    """
    Load csv file into sqlite table
    """
    parts = p.split(os.path.sep)
    table = parts[-1].replace('.csv', '')
    print('Loading {t} from {p}...'.format(t=table, p=p))
    names = cols(table)
    df = pandas.read_csv(p, sep=CSV_SEP, header=None, names=names)
    df.to_sql(table, conn, if_exists='append', index=False)

def download(url):
    """
    Download file at specified url
    """
    local_filename = url.split('/')[-1]
    if not os.path.exists(local_filename):
        print('Downloading {url} to {filename}...'.format(url=url, filename=local_filename))
        r = requests.get(url, stream=True)
        with open(local_filename, 'wb') as f:
            for chunk in r.iter_content(chunk_size=1024):
                if chunk:
                    f.write(chunk)
    return local_filename

def extract(zp, path):
    """
    Extract a zip file to specified path
    """
    if not os.path.exists(path):
        print('Extracting {zp} to {path}'.format(zp=zp, path=path))
        os.makedirs(path)
        z = ZipFile(zp)
        z.extractall(path)

def sql_script(p):
    """
    Execute the sql script at specified path
    """
    cur = conn.cursor()
    sql = read_text(p)
    cur.executescript(sql)

def run():
    zp = download(SYNPUF_URL)
    synpuf_path = zp.replace('.zip', '')
    extract(zp, synpuf_path)
    sql_script(DDL_PATH)
    for p in ls_csv(synpuf_path):
        load_csv(p)
# -


if __name__ == '__main__':
    run()
