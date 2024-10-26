(: 5 :)
(: doc("db/bib/bib.xml")//author/last :)

(: 6
for $book in doc("db/bib/bib.xml")//book
for $title in $book/title
for $author in $book/author
return 
  <ksiazka>
    <title>{$title/text()}</title>
      <author>
        <first>{$author/first/text()}</first>
        <last>{$author/last/text()}</last>
       </author>
  </ksiazka> :)

(: 7    
for $book in doc("db/bib/bib.xml")//book
for $title in $book/title
for $author in $book/author
return
  <ksiazka>
    <tytul>{$title/text()}</tytul>
    <autor>{$author/last/text()}{$author/first/text()}</autor>
  </ksiazka> :)
  
(: 8
for $book in doc("db/bib/bib.xml")//book
for $title in $book/title
for $author in $book/author
return
  <ksiazka>
    <tytul>{$title/text()}</tytul>
    <autor>{concat($author/last/text(), " ", $author/first/text())}</autor>
  </ksiazka> :)
  
(: 9
<wynik>
  {
    for $book in doc("db/bib/bib.xml")//book
    for $title in $book/title
    for $author in $book/author
    return
      <ksiazka>
        <tytul>{$title/text()}</tytul>
        <autor>{concat($author/last/text(), " ", $author/first/text())}</autor>
      </ksiazka>
  }
</wynik> :)

(: 10
<imiona>
 {doc("db/bib/bib.xml")//book[title = "Data on the Web"]/author/first}
</imiona> :)

(: 11a
<DataOnTheWeb>
  {doc("db/bib/bib.xml")//book[title = "Data on the Web"]}
</DataOnTheWeb> :)

(: 11b
<DataOnTheWeb>
  {for $book in doc("db/bib/bib.xml")//book
    where $book/title = "Data on the Web"
    return $book
  }
</DataOnTheWeb> :)

(: 13
for $book in doc("db/bib/bib.xml")//book
where contains($book/title, "Data")
return 
  <Data>
    <title>{$book/title/text()}</title>
    {
      for $author in $book/author
      return <nazwisko>{$author/last/text()}</nazwisko>
    }
  </Data> :)
  
(: 14
for $book in doc("db/bib/bib.xml")//book
where count($book/author)<= 2
return $book/title :)

(: 15
for $book in doc("db/bib/bib.xml")//book
return
  <ksiazka>
    {$book/title}
    <autorow>{count($book/author)}</autorow>
  </ksiazka> :)
  
(: 16
let $years := doc("db/bib/bib.xml")//book/@year
return 
  <przedział>{concat(min($years), " - ", max($years))}</przedział> :)
  
(: 17
let $prices := doc("db/bib/bib.xml")//book/price
return <roznica>{max($prices)-min($prices)}</roznica> :)

(: 18
let $minPrice := min(doc("db/bib/bib.xml")//book/price)
for $book in doc("db/bib/bib.xml")//book[price = $minPrice]
  return
    <najtańsze>
      <najtańsza>
       {$book/title}
       <author>
       {
         for $author in $book/author
         return <author>
                   {$author/last}
                   {$author/first}
                </author>
       }
       </author>
      </najtańsza>
    </najtańsze> :)
    
(: 19
for $author in doc("db/bib/bib.xml")//author/last
let $books := doc("db/bib/bib.xml")//book[author/last = $author/text()]
return
  <autor>
    {$author}
    {
      for $book in $books
      return $book/title
    }
  </autor> :)
 
(: 20 
collection("db/shakespeare")//PLAY/TITLE :)


(: 21
for $play in collection("db/shakespeare")//PLAY
where some $line in $play/ACT/SCENE/SPEECH/LINE satisfies
contains($line, "or not to be")
return $play/TITLE :)

(: 22 :)
for $play in collection("db/shakespeare")//PLAY
return
  <sztuka tytul="{$play/TITLE/text()}">
  <postaci>{count($play/PERSONAE/PERSONA | $play/PERSONAE/PGROUP/PERSONA)}</postaci>
  <aktow>{count($play/ACT)}</aktow>
  <scen>{count($play/ACT/SCENE)}</scen>
  </sztuka>







  
