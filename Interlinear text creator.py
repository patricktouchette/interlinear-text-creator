import string
from datetime import datetime

startTime = datetime.now()

#Create the dictionary
with open('dictionary.txt', 'r', encoding='utf8') as f:
    dictionary = f.readlines()

dict1 = {}
for line in dictionary:
    t = line.split('\t')
    dict1[t[0]] = t[1].rstrip('\n')

keys = dict1.keys()


#Open the text to be processed
filename = 'text_input.txt'
with open(filename, 'r', encoding='utf8') as f:
    text = f.read()
clean_text = text.replace(' ',' ') #weird encoded space character \uA0
word_list = clean_text.split()
words_list_lowercase = [w.lower() for w in word_list]

#Function used to remove punctuation from the words
def remove_punctuation(word):
    punct_startswith = ['–','«']
    punct_endswith = ['.', ',','?','!','»','"','”','…','–',':',';']
    punct_endswith2 = ['?»','!»','.»','?!']
    pre_punct = ''
    punct = ''
    for pp in punct_startswith:
        if word.startswith(pp):
            word = word[len(pp):]
            pre_punct = pre_punct + pp
    for p in punct_endswith:
        if word.endswith(p):
            word = word[:-len(p)]
            punct = p + punct
    return [word, pre_punct, punct]



#Remove all punctuation from the words in the input text.
i = 0
for word in words_list_lowercase:
    clean_word, pre_punct, punct = remove_punctuation(word)
    words_list_lowercase[i] = clean_word
    #print clean_word
    i = i + 1

#RUN TWICE FOR GOOD MEASURE
#Remove all punctuation from the words in the input text.
i = 0
for word in words_list_lowercase:
    clean_word, pre_punct, punct = remove_punctuation(word)
    words_list_lowercase[i] = clean_word
    i = i + 1



#Remove duplicate words and output them
with open('words_list_to_translate.txt','w',encoding='utf8') as out:
    word_set = sorted(set(words_list_lowercase))
    word_count = 0
    for word in word_set:
        if word not in dict1:
            out.write(word + '\n')
            word_count = word_count + 1
    print('The total word count of this text is: %s' %len(word_list))
    print('The unique word count of this text is: %s' %len(word_set))
    print('The total amount of new words is: %s' %word_count)



#Write the interlinear text
def interlineate(filename):
    processingTime = datetime.now()

    textfile = open(filename, 'r', encoding='utf8')
    text = textfile.read()
    output = open('output.html','w',encoding='utf8')
    missed_words_file = open('missed_words.txt','w',encoding='utf8')
    missed_words = []
    number_of_sentences = text.count('\n')
    #output.write('<ruby>\n')
    print('The number of sentences is: %s' % number_of_sentences)
    n = 0
    #put Size 3 for ereader Calibre epub format. Size 6 for PDF.
    output.write('''
    <html>
    <font size="3">
    <font face = "Verdana">
    <style type="text/css">
    }
    </style>''')
    output.write('\n  ')
    while n < number_of_sentences:
        n = n + 1
        start_pos = 0
        end_pos = text.find('\n')
        words = text[start_pos:end_pos+1].split()
        for w in words:
            word, pre_punct, punct = remove_punctuation(w)
            output.write('<ruby>\n')
            #word = word.decode('utf-8')
            output.write('<rb>' + pre_punct + word + punct + '</rb>\n') #word
            word = word.lower()
            if word in keys:
                #output.write('<rp> (</rp>')
                output.write('<rt>' + dict1[word] + '</rt>\n')
                #output.write('<rp>) </rp>')
            output.write('</ruby>\n')
            #output.write('&nbsp;')
            if word not in keys:
                missed_words.append(word)
        output.write('<br />')
        text = text[end_pos+1:]
    #output.write('</ruby>\n')

    output.write('</html>')
    missed_words = set(missed_words)
    for word in missed_words:
        if word not in keys:
            missed_words_file.write(word + '\n')
    output.close()
    missed_words_file.close()
    textfile.close()
    print('The amount of words with no translatation is: %s'  % len(missed_words))
    print('Chapter Processing time: %')
    print(datetime.now()-processingTime)
    print('Total processing time: %')
    print(datetime.now()-startTime)


#For processing multiple files
def multiple_file_loop():
    n = 1
    number_of_files = 100
    while n <= number_of_files:
        if n < 10:
            zero = '0'
        else:
            zero = ''
        print('==========================================')
        print(' Launching text %s%s' % (zero, n))
        filename = 'Chapters/Chapter %s%s' % (zero, n)
        interlineate(filename)
        n = n + 1



def chapter_split():
    text2 = open(filename + '.txt').read()
    print('The text length is: %s' %len(text2))
    chapters = text2.split('Глава ')
    print('There are this many chapters: %s' %len(chapters))
    paragraphs = text2.split('.')
    print('There are this many paragraphs: %s' %len(paragraphs))
    n = 1
    for c in chapters:
        if n < 10:
            zero = '0'
        else:
            zero = ''
        print(' Writing text %s%s' % (zero, n))
        chapter_name = 'Chapters/Chapter %s%s' % (zero, n)
        output = open(chapter_name + '.txt','wb+')
        output.write(c)
        output.close()
        n = n + 1



interlineate(filename)
#chapter_split()
#multiple_file_loop()
