(:for $k in doc('C:/Studia/IX/ZTPD/ZTPD/lab8/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ[starts-with(NAZWA, substring(STOLICA, 1, 1))]:)
(:return <KRAJ>:)
(: {$k/NAZWA, $k/STOLICA}:)
(:</KRAJ>:)

(:doc('C:/Studia/IX/ZTPD/ZTPD/lab8/XPath-XSLT/swiat.xml')//KRAJ:)

(:XPath:)

(:zad 31:)
(:doc('C:/Studia/IX/ZTPD/ZTPD/lab8/XPath-XSLT/zesp_prac.xml'):)

(:zad 32:)
(:doc('C:/Studia/IX/ZTPD/ZTPD/lab8/XPath-XSLT/zesp_prac.xml')//NAZWISKO:)

(:zad 33:)
(:doc('C:/Studia/IX/ZTPD/ZTPD/lab8/XPath-XSLT/zesp_prac.xml')//ROW[NAZWA='SYSTEMY EKSPERCKIE']//NAZWISKO:)

(:zad 34:)
(:count(doc('C:/Studia/IX/ZTPD/ZTPD/lab8/XPath-XSLT/zesp_prac.xml')//ROW[ID_ZESP=10]/PRACOWNICY/ROW):)

(:zad 35:)
(:doc('C:/Studia/IX/ZTPD/ZTPD/lab8/XPath-XSLT/zesp_prac.xml')//PRACOWNICY/ROW[ID_SZEFA=100]/NAZWISKO:)

(:zad 36:)
sum(doc('C:/Studia/IX/ZTPD/ZTPD/lab8/XPath-XSLT/zesp_prac.xml')//PRACOWNICY/ROW[ID_ZESP=//PRACOWNICY/ROW[NAZWISKO='BRZEZINSKI']/ID_ZESP]//PLACA_POD)