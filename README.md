# interlinear-text-creator
Creates an interlinear book from a Russian text, as shown in the image below. The English translation is displayed above the Russian word in HTML ruby notation. 
Uses python 3.6

# To DO
-Clean up code, this is old stuff
-Create a GUI interface in tkinter

![alt text](https://github.com/patricktouchette/interlinear-text-creator/blob/master/screenshot.png?raw=true)


# Workflow
1. Copy your text to translate to text_input.txt
2. Run Interlinear text creator.py
3. Copy the words from words_list_to_translate.txt
4. Paste into a google spreadsheet onto a column
5. Create a rule in the second column =GOOGLETRANSLATE(A1,"ru","en")
6. Copy the google spreadsheet result into dictionary.txt
7. Run the script
8. The file output.html will be created
9. You have successfully created an interlinear text

