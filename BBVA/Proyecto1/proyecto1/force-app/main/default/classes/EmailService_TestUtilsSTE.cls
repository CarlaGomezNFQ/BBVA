global with sharing class EmailService_TestUtilsSTE {//NOSONAR

    /*Constant String aplicationpdf*/
    public static final string PDF = 'application/pdf';  
    /*Constant filename*/
    public static final string FILENAME = 'filename';
    /*Constant text*/
    public static final string TEXT = 'text'; 
    /*Constant Content-type*/
    public static final string CONTENT_TYPE = 'Content-type';
    
        /*-------------------------------------------------------------------------------
    Description:   Method that executes the creation of an email with text attachment. (STE)
    ---------------------------------------------------------------------------------*/ 
    public static Messaging.InboundEmail.TextAttachment textAttSTE() {
        final Messaging.InboundEmail.TextAttachment tta = new Messaging.InboundEmail.TextAttachment();
        tta.body = 'body';
        tta.charset = 'UTF-8';
        tta.bodyIsTruncated = true;
        tta.filename = FILENAME;
        tta.headers = new List<Messaging.InboundEmail.Header>();
        final Messaging.InboundEmail.Header tacontenttype = new Messaging.InboundEmail.Header();
        final Messaging.InboundEmail.Header tacontentid = new Messaging.InboundEmail.Header();
        final Messaging.InboundEmail.Header taconttransfcod = new Messaging.InboundEmail.Header();
        tacontenttype.name = CONTENT_TYPE;
        tacontenttype.value = TEXT;
        tta.headers.add(tacontenttype);
        tta.headers.add(tacontentid);
        tta.headers.add(taconttransfcod);
        tta.mimetypesubtype = PDF;
        return tta;
    }

    /*-------------------------------------------------------------------------------
    Description:   Method that executes the creation of an email with binary attachment +4kbs & ContentType (STE)
    ---------------------------------------------------------------------------------*/ 
    public static Messaging.InboundEmail.BinaryAttachment binaryAttPlus4kbContentTypeSTE() {
        final Messaging.InboundEmail.BinaryAttachment batt = new Messaging.InboundEmail.BinaryAttachment();
        batt.body = Blob.toPdf('Quod equidem non reprehendo Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quibus natura iure responderit non esse verum aliunde finem beate vivendi, a se principia rei gerendae peti  Quae enim adhuc protulisti, popularia sunt, ego autem a te elegantiora desidero. Duo Reges: constructio interrete. Tum Lucius: Mihi vero ista valde probata sunt, quod item fratri puto. Bestiarum vero nullum iudicium puto. Nihil enim iam habes, quod ad corpus referas  Deinde prima illa, quae in congressu solemus: Quid tu, inquit, huc? Et homini, qui ceteris animantibus plurimum praestat, praecipue a natura nihil datum esse dicemus? Iam id ipsum absurdum, maximum malum neglegi. Quod ea non occurrentia fingunt, vincunt Aristonem  Atqui perspicuum est hominem e corpore animoque constare, cum primae sint animi partes, secundae corporis. Fieri, inquam, Triari, nullo pacto potest, ut non dicas, quid non probes eius, a quo dissentias. Equidem e Cn. An dubium est, quin virtus ita maximam partem optineat in rebus humanis, ut reliquas obruat?mQuis istum dolorem timet? Summus dolor plures dies manere non potest? Dicet pro me ipsa virtus nec dubitabit isti vestro beato M. Tubulum fuisse, qua illum, cuius is condemnatus est rogatione, P. Quod si ita sit, cur opera philosophiae sit danda nescio. Ex eorum enim scriptis et institutis cum omnis doctrina liberalis, omnis historia. Quod si ita est, sequitur id ipsum, quod te velle video, omnes semper beatos esse sapientes. Cum enim fertur quasi torrens oratio, quamvis multa cuiusque modi rapiat, nihil tamen teneas, nihil apprehendas, nusquam orationem rapidam coerceas. Ita redarguitur ipse a sese, convincunturque scripta eius probitate ipsius ac moribus. At quanta conantur! Mundum hunc omnem oppidum esse nostrum! Incendi igitur eos, qui audiunt, vides. Vide, ne magis, inquam, tuum fuerit, cum re idem tibi, quod mihi, videretur, non nova te rebus nomina inponere. Qui-vere falsone, quaerere mittimus-dicitur oculis se privasse  Si ista mala sunt, in quae potest incidere sapiens, sapientem esse non esse ad beate vivendum satis. At vero si ad vitem sensus accesserit, ut appetitum quendam habeat et per se ipsa moveatur, quid facturam putas? Quem si tenueris, non modo meum Ciceronem, sed etiam me ipsum abducas licebit. Stulti autem malorum memoria torquentur, sapientes bona praeterita grata recordatione renovata delectant.Esse enim quam vellet iniquus iustus poterat inpune. Quae autem natura suae primae institutionis oblita est Verum tamen cum de rebus grandioribus dicas, ipsae res verba rapiunt  Hoc est non modo cor non habere, sed ne palatum quidem. Voluptatem cum summum bonum diceret, primum in eo ipso parum vidit, deinde hoc quoque alienum  Sed tu istuc dixti bene Latine, parum plane. Nam haec ipsa mihi erunt in promptu, quae modo audivi, nec ante aggrediar, quam te ab istis, quos dicis, instructum videro. Fatebuntur Stoici haec omnia dicta esse praeclare, neque eam causam Zenoni desciscendi fuisse. Non autem hoc: igitur ne illud quidem. Ratio quidem vestra sic cogit. Cum audissem Antiochum, Brute, ut solebam, cum M. An quod ita callida est, ut optime possit architectari voluptates? Idemne, quod iucunde? Haec mihi videtur delicatior, ut ita dicam, molliorque ratio, quam virtutis vis gravitasque postulat. Sed quoniam et advesperascit et mihi ad villam revertendum est, nunc quidem hactenus  Cuius ad naturam apta ratio vera illa et summa lex a philosophis dicitur. Neque solum ea communia, verum etiam paria esse dixerunt. Sed nunc, quod agimus  A mene tu? Quod equidem non reprehendo  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quibus natura iure responderit non esse verum aliunde finem beate vivendi, a se principia rei gerendae peti  Quae enim adhuc protulisti, popularia sunt, ego autem a te elegantiora desidero. Duo Reges: constructio interrete. Tum Lucius: Mihi vero ista valde probata sunt, quod item fratri puto. Bestiarum vero nullum iudicium puto. Nihil enim iam habes, quod ad corpus referas  Deinde prima illa, quae in congressu solemus: Quid tu, inquit, huc? Et homini, qui ceteris animantibus plurimum praestat, praecipue a natura nihil datum esse dicemus? Iam id ipsum absurdum, maximum malum neglegi. Quod ea non occurrentia fingunt, vincunt Aristonem  Atqui perspicuum est hominem e corpore animoque constare, cum primae sint animi partes, secundae corporis. Fieri, inquam, Triari, nullo pacto potest, ut non dicas, quid non probes eius, a quo dissentias. Equidem e Cn. An dubium est, quin virtus ita maximam partem optineat in rebus humanis, ut reliquas obruat? Quis istum dolorem timet? Summus dolor plures dies manere non potest? Dicet pro me ipsa virtus nec dubitabit isti vestro beato M. Tubulum fuisse, qua illum, cuius is condemnatus est rogatione, P. Quod si ita sit, cur opera philosophiae sit danda nescio. Ex eorum enim scriptis et institutis cum omnis doctrina liberalis, omnis historia. Quod si ita est, sequitur id ipsum, quod te velle video, omnes semper beatos esse sapientes. Cum enim fertur quasi torrens oratio, quamvis multa cuiusque modi rapiat, nihil tamen teneas, nihil apprehendas, nusquam orationem rapidam coerceas. Ita redarguitur ipse a sese, convincunturque scripta eius probitate ipsius ac moribus. At quanta conantur! Mundum hunc omnem oppidum esse nostrum! Incendi igitur eos, qui audiunt, vides. Vide, ne magis, inquam, tuum fuerit, cum re idem tibi, quod mihi, videretur, non nova te rebus nomina inponere. Qui-vere falsone, quaerere mittimus-dicitur oculis se privasse  Si ista mala sunt, in quae potest incidere sapiens, sapientem esse non esse ad beate vivendum satis. At vero si ad vitem sensus accesserit, ut appetitum quendam habeat et per se ipsa moveatur, quid facturam putas? Quem si tenueris, non modo meum Ciceronem, sed etiam me ipsum abducas licebit. Stulti autem malorum memoria torquentur, sapientes bona praeterita grata recordatione renovata delectant. Esse enim quam vellet iniquus iustus poterat inpune. Quae autem natura suae primae institutionis oblita est? Verum tamen cum de rebus grandioribus dicas, ipsae res verba rapiunt  Hoc est non modo cor non habere, sed ne palatum quidem. Voluptatem cum summum bonum diceret, primum in eo ipso parum vidit, deinde hoc quoque alienum  Sed tu istuc dixti bene Latine, parum plane. Nam haec ipsa mihi erunt in promptu, quae modo audivi, nec ante aggrediar, quam te ab istis, quos dicis, instructum videro. Fatebuntur Stoici haec omnia dicta esse praeclare, neque eam causam Zenoni desciscendi fuisse. Non autem hoc: igitur ne illud quidem. Ratio quidem vestra sic cogit. Cum audissem Antiochum, Brute, ut solebam, cum M. An quod ita callida est, ut optime possit architectari voluptates? Idemne, quod iucunde? Haec mihi videtur delicatior, ut ita dicam, molliorque ratio, quam virtutis vis gravitasque postulat. Sed quoniam et advesperascit et mihi ad villam revertendum est, nunc quidem hactenus  Cuius ad naturam apta ratio vera illa et summa lex a philosophis dicitur. Neque solum ea communia, verum etiam paria esse dixerunt. Sed nunc, quod agimus  A mene tu?');
        batt.filename = FILENAME;
        batt.headers = new List<Messaging.InboundEmail.Header>();
        final Messaging.InboundEmail.Header bacontenttype = new Messaging.InboundEmail.Header();
        final Messaging.InboundEmail.Header bacontentid = new Messaging.InboundEmail.Header();
        final Messaging.InboundEmail.Header baconttransfcod= new Messaging.InboundEmail.Header();
 		bacontenttype.name = CONTENT_TYPE;
        bacontenttype.value = TEXT;
        batt.headers.add(bacontenttype);
        batt.headers.add(bacontentid);
        batt.headers.add(baconttransfcod);
        batt.mimetypesubtype = PDF;
        return batt;
    }
   
    /*-------------------------------------------------------------------------------
    Description:   Method that executes the creation of an email with binary attachment -4kbs (STE)
    ---------------------------------------------------------------------------------*/ 
    public static Messaging.InboundEmail.BinaryAttachment binaryAttMinus4kbSTE() {
        final Messaging.InboundEmail.BinaryAttachment batt = new Messaging.InboundEmail.BinaryAttachment();
        batt.body = Blob.toPdf('Lorem ipsum dolor sit amet, elit adipiscing consectetuer. Aenean commodo ligula eget dolor. Massa Aenean. Cum sociis natoque penatibus et Magnis dis parturienta montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat Massa quis enim. Donec Justo pede, vel fringilla, nec aliquet, eget vulputate, arcu. En enim Justo, rhoncus ut, un imperdiet, venenatis vitae, Justo. Nullam dictado felis eu pede mollis Pretium. tincidunt entero. dapibus Cras. Vivamus elementum semper nisi. Aenean Tellus eleifend vulputate. Aenean leo ligula, porttitor eu, consequat vitae, ac eleifend, enim. Aliquam lorem ante, en dapibus, viverra quis, feugiat una, Tellus. Phasellus viverra nulla ut metus varius laoreet. rutrum quisque. imperdiet Aenean. Etiam ultricies nisi vel augue. Curabitur Ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Mecenas tempus, Tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem ñeque SED ipsum. Nam quam nunc, blandit cinco Lorem ipsum dolor sit amet, elit adipiscing consectetuer. ');
        batt.filename = FILENAME;
        batt.headers = new List<Messaging.InboundEmail.Header>();
        final Messaging.InboundEmail.Header bacontenttype = new Messaging.InboundEmail.Header();
        final Messaging.InboundEmail.Header bacontentid = new Messaging.InboundEmail.Header();
        final Messaging.InboundEmail.Header baconttransfcod= new Messaging.InboundEmail.Header();
        bacontenttype.name = CONTENT_TYPE;
        bacontenttype.value = TEXT;
        batt.headers.add(bacontenttype);
        batt.headers.add(bacontenttype);
        batt.headers.add(bacontentid);
        batt.headers.add(baconttransfcod);
        batt.mimetypesubtype = PDF;
        return batt;
    }
    
}