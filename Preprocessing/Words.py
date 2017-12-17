import nltk
from nltk import word_tokenize
from nltk.stem import SnowballStemmer


stemmer = SnowballStemmer('spanish')
text = 'En su parte de arriba encontramos la ";zona de mandos";, donde se puede echar el detergente, aunque en nuestro caso lo al ser gel lo ponemos directamente junto con la ropa.'
stemmed_text = [stemmer.stem(i) for i in word_tokenize(text)]
print(stemmed_text)