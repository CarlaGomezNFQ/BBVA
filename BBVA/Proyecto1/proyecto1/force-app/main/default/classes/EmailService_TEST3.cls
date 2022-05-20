@isTest
/*
  Test class 3 for Email Service 
*/
public class EmailService_TEST3 {

    /*Email Addres Routing Rules*/
    public static final string EMAIL_ROUTING = 'cds@bbva.com';
    /*Constant String aplicationpdf*/
    public static final string PDF = 'application/pdf';  
    /*Constant filename*/
    public static final string FILENAME = 'filename';
    /* Constant Min size Attachment*/
    public static final integer SIZE = 3000;
    /*Constant text*/
    public static final string TEXT = 'text'; 
    /*Constant Content-type*/
    public static final string CONTENT_TYPE = 'Content-type';
    /*Constant plaintextbody7*/
    public static final string PLAIN_TEXT = 'plaintextbody7';
    /*Constant subject*/
    public static final string SUBJECT = 'Subject7';
    /*Constant From*/
    public static final string FROM_7 = 'From7';
    /*Constant Email*/
    public static final string FROM_EMAIL = 'fromaddress7@email.com';
    /*Constant Email Rule*/
    public static final string EMAIL_RULE = 'emailrule@email.com';
    /*Constant Email From Address*/
    public static final string FROM_ADD = 'fromaddress@email.com';


    @isTest
    /*-------------------------------------------------------------------------------
    Description:   Method that executes the creation of an email without an address STE.
    ---------------------------------------------------------------------------------*/ 
    public static void fullFlowNoAddressesSTE() {
        EmailService_TestUtils.bypassall();
        final Messaging.InboundEmail email = new Messaging.InboundEmail();
        final Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        envelope.fromAddress = FROM_ADD;
        envelope.toaddress = EMAIL_RULE;
        final List<Messaging.InboundEmail.Header> headers = new List<Messaging.InboundEmail.Header>();
        final Messaging.InboundEmail.Header messageid = new Messaging.InboundEmail.Header();
        messageid.name = 'Message-IDSTE';
        messageid.value = 'messageidSTE';
        email.fromAddress = FROM_ADD;
        email.headers = headers;
        email.subject = 'Subject2';
        email.htmlBody = 'Quod equidem non reprehendo Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quibus natura iure responderit non esse verum aliunde finem beate vivendi, a se principia rei gerendae peti  Quae enim adhuc protulisti, popularia sunt, ego autem a te elegantiora desidero. Duo Reges: constructio interrete. Tum Lucius: Mihi vero ista valde probata sunt, quod item fratri puto. Bestiarum vero nullum iudicium puto. Nihil enim iam habes, quod ad corpus referas  Deinde prima illa, quae in congressu solemus: Quid tu, inquit, huc? Et homini, qui ceteris animantibus plurimum praestat, praecipue a natura nihil datum esse dicemus? Iam id ipsum absurdum, maximum malum neglegi. Quod ea non occurrentia fingunt, vincunt Aristonem  Atqui perspicuum est hominem e corpore animoque constare, cum primae sint animi partes, secundae corporis. Fieri, inquam, Triari, nullo pacto potest, ut non dicas, quid non probes eius, a quo dissentias. Equidem e Cn. An dubium est, quin virtus ita maximam partem optineat in rebus humanis, ut reliquas obruat?mQuis istum dolorem timet? Summus dolor plures dies manere non potest? Dicet pro me ipsa virtus nec dubitabit isti vestro beato M. Tubulum fuisse, qua illum, cuius is condemnatus est rogatione, P. Quod si ita sit, cur opera philosophiae sit danda nescio. Ex eorum enim scriptis et institutis cum omnis doctrina liberalis, omnis historia. Quod si ita est, sequitur id ipsum, quod te velle video, omnes semper beatos esse sapientes. Cum enim fertur quasi torrens oratio, quamvis multa cuiusque modi rapiat, nihil tamen teneas, nihil apprehendas, nusquam orationem rapidam coerceas. Ita redarguitur ipse a sese, convincunturque scripta eius probitate ipsius ac moribus. At quanta conantur! Mundum hunc omnem oppidum esse nostrum! Incendi igitur eos, qui audiunt, vides. Vide, ne magis, inquam, tuum fuerit, cum re idem tibi, quod mihi, videretur, non nova te rebus nomina inponere. Qui-vere falsone, quaerere mittimus-dicitur oculis se privasse  Si ista mala sunt, in quae potest incidere sapiens, sapientem esse non esse ad beate vivendum satis. At vero si ad vitem sensus accesserit, ut appetitum quendam habeat et per se ipsa moveatur, quid facturam putas? Quem si tenueris, non modo meum Ciceronem, sed etiam me ipsum abducas licebit. Stulti autem malorum memoria torquentur, sapientes bona praeterita grata recordatione renovata delectant.Esse enim quam vellet iniquus iustus poterat inpune. Quae autem natura suae primae institutionis oblita est Verum tamen cum de rebus grandioribus dicas, ipsae res verba rapiunt  Hoc est non modo cor non habere, sed ne palatum quidem. Voluptatem cum summum bonum diceret, primum in eo ipso parum vidit, deinde hoc quoque alienum  Sed tu istuc dixti bene Latine, parum plane. Nam haec ipsa mihi erunt in promptu, quae modo audivi, nec ante aggrediar, quam te ab istis, quos dicis, instructum videro. Fatebuntur Stoici haec omnia dicta esse praeclare, neque eam causam Zenoni desciscendi fuisse. Non autem hoc: igitur ne illud quidem. Ratio quidem vestra sic cogit. Cum audissem Antiochum, Brute, ut solebam, cum M. An quod ita callida est, ut optime possit architectari voluptates? Idemne, quod iucunde? Haec mihi videtur delicatior, ut ita dicam, molliorque ratio, quam virtutis vis gravitasque postulat. Sed quoniam et advesperascit et mihi ad villam revertendum est, nunc quidem hactenus  Cuius ad naturam apta ratio vera illa et summa lex a philosophis dicitur. Neque solum ea communia, verum etiam paria esse dixerunt. Sed nunc, quod agimus  A mene tu? Quod equidem non reprehendo  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quibus natura iure responderit non esse verum aliunde finem beate vivendi, a se principia rei gerendae peti  Quae enim adhuc protulisti, popularia sunt, ego autem a te elegantiora desidero. Duo Reges: constructio interrete. Tum Lucius: Mihi vero ista valde probata sunt, quod item fratri puto. Bestiarum vero nullum iudicium puto. Nihil enim iam habes, quod ad corpus referas  Deinde prima illa, quae in congressu solemus: Quid tu, inquit, huc? Et homini, qui ceteris animantibus plurimum praestat, praecipue a natura nihil datum esse dicemus? Iam id ipsum absurdum, maximum malum neglegi. Quod ea non occurrentia fingunt, vincunt Aristonem  Atqui perspicuum est hominem e corpore animoque constare, cum primae sint animi partes, secundae corporis. Fieri, inquam, Triari, nullo pacto potest, ut non dicas, quid non probes eius, a quo dissentias. Equidem e Cn. An dubium est, quin virtus ita maximam partem optineat in rebus humanis, ut reliquas obruat? Quis istum dolorem timet? Summus dolor plures dies manere non potest? Dicet pro me ipsa virtus nec dubitabit isti vestro beato M. Tubulum fuisse, qua illum, cuius is condemnatus est rogatione, P. Quod si ita sit, cur opera philosophiae sit danda nescio. Ex eorum enim scriptis et institutis cum omnis doctrina liberalis, omnis historia. Quod si ita est, sequitur id ipsum, quod te velle video, omnes semper beatos esse sapientes. Cum enim fertur quasi torrens oratio, quamvis multa cuiusque modi rapiat, nihil tamen teneas, nihil apprehendas, nusquam orationem rapidam coerceas. Ita redarguitur ipse a sese, convincunturque scripta eius probitate ipsius ac moribus. At quanta conantur! Mundum hunc omnem oppidum esse nostrum! Incendi igitur eos, qui audiunt, vides. Vide, ne magis, inquam, tuum fuerit, cum re idem tibi, quod mihi, videretur, non nova te rebus nomina inponere. Qui-vere falsone, quaerere mittimus-dicitur oculis se privasse  Si ista mala sunt, in quae potest incidere sapiens, sapientem esse non esse ad beate vivendum satis. At vero si ad vitem sensus accesserit, ut appetitum quendam habeat et per se ipsa moveatur, quid facturam putas? Quem si tenueris, non modo meum Ciceronem, sed etiam me ipsum abducas licebit. Stulti autem malorum memoria torquentur, sapientes bona praeterita grata recordatione renovata delectant. Esse enim quam vellet iniquus iustus poterat inpune. Quae autem natura suae primae institutionis oblita est? Verum tamen cum de rebus grandioribus dicas, ipsae res verba rapiunt  Hoc est non modo cor non habere, sed ne palatum quidem. Voluptatem cum summum bonum diceret, primum in eo ipso parum vidit, deinde hoc quoque alienum  Sed tu istuc dixti bene Latine, parum plane. Nam haec ipsa mihi erunt in promptu, quae modo audivi, nec ante aggrediar, quam te ab istis, quos dicis, instructum videro. Fatebuntur Stoici haec omnia dicta esse praeclare, neque eam causam Zenoni desciscendi fuisse. Non autem hoc: igitur ne illud quidem. Ratio quidem vestra sic cogit. Cum audissem Antiochum, Brute, ut solebam, cum M. An quod ita callida est, ut optime possit architectari voluptates? Idemne, quod iucunde? Haec mihi videtur delicatior, ut ita dicam, molliorque ratio, quam virtutis vis gravitasque postulat. Sed quoniam et advesperascit et mihi ad villam revertendum est, nunc quidem hactenus  Cuius ad naturam apta ratio vera illa et summa lex a philosophis dicitur. Neque solum ea communia, verum etiam paria esse dixerunt. Sed nunc, quod agimus  A mene tu?';
        email.plainTextBody = 'Quod equidem non reprehendo Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quibus natura iure responderit non esse verum aliunde finem beate vivendi, a se principia rei gerendae peti  Quae enim adhuc protulisti, popularia sunt, ego autem a te elegantiora desidero. Duo Reges: constructio interrete. Tum Lucius: Mihi vero ista valde probata sunt, quod item fratri puto. Bestiarum vero nullum iudicium puto. Nihil enim iam habes, quod ad corpus referas  Deinde prima illa, quae in congressu solemus: Quid tu, inquit, huc? Et homini, qui ceteris animantibus plurimum praestat, praecipue a natura nihil datum esse dicemus? Iam id ipsum absurdum, maximum malum neglegi. Quod ea non occurrentia fingunt, vincunt Aristonem  Atqui perspicuum est hominem e corpore animoque constare, cum primae sint animi partes, secundae corporis. Fieri, inquam, Triari, nullo pacto potest, ut non dicas, quid non probes eius, a quo dissentias. Equidem e Cn. An dubium est, quin virtus ita maximam partem optineat in rebus humanis, ut reliquas obruat?mQuis istum dolorem timet? Summus dolor plures dies manere non potest? Dicet pro me ipsa virtus nec dubitabit isti vestro beato M. Tubulum fuisse, qua illum, cuius is condemnatus est rogatione, P. Quod si ita sit, cur opera philosophiae sit danda nescio. Ex eorum enim scriptis et institutis cum omnis doctrina liberalis, omnis historia. Quod si ita est, sequitur id ipsum, quod te velle video, omnes semper beatos esse sapientes. Cum enim fertur quasi torrens oratio, quamvis multa cuiusque modi rapiat, nihil tamen teneas, nihil apprehendas, nusquam orationem rapidam coerceas. Ita redarguitur ipse a sese, convincunturque scripta eius probitate ipsius ac moribus. At quanta conantur! Mundum hunc omnem oppidum esse nostrum! Incendi igitur eos, qui audiunt, vides. Vide, ne magis, inquam, tuum fuerit, cum re idem tibi, quod mihi, videretur, non nova te rebus nomina inponere. Qui-vere falsone, quaerere mittimus-dicitur oculis se privasse  Si ista mala sunt, in quae potest incidere sapiens, sapientem esse non esse ad beate vivendum satis. At vero si ad vitem sensus accesserit, ut appetitum quendam habeat et per se ipsa moveatur, quid facturam putas? Quem si tenueris, non modo meum Ciceronem, sed etiam me ipsum abducas licebit. Stulti autem malorum memoria torquentur, sapientes bona praeterita grata recordatione renovata delectant.Esse enim quam vellet iniquus iustus poterat inpune. Quae autem natura suae primae institutionis oblita est Verum tamen cum de rebus grandioribus dicas, ipsae res verba rapiunt  Hoc est non modo cor non habere, sed ne palatum quidem. Voluptatem cum summum bonum diceret, primum in eo ipso parum vidit, deinde hoc quoque alienum  Sed tu istuc dixti bene Latine, parum plane. Nam haec ipsa mihi erunt in promptu, quae modo audivi, nec ante aggrediar, quam te ab istis, quos dicis, instructum videro. Fatebuntur Stoici haec omnia dicta esse praeclare, neque eam causam Zenoni desciscendi fuisse. Non autem hoc: igitur ne illud quidem. Ratio quidem vestra sic cogit. Cum audissem Antiochum, Brute, ut solebam, cum M. An quod ita callida est, ut optime possit architectari voluptates? Idemne, quod iucunde? Haec mihi videtur delicatior, ut ita dicam, molliorque ratio, quam virtutis vis gravitasque postulat. Sed quoniam et advesperascit et mihi ad villam revertendum est, nunc quidem hactenus  Cuius ad naturam apta ratio vera illa et summa lex a philosophis dicitur. Neque solum ea communia, verum etiam paria esse dixerunt. Sed nunc, quod agimus  A mene tu? Quod equidem non reprehendo  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quibus natura iure responderit non esse verum aliunde finem beate vivendi, a se principia rei gerendae peti  Quae enim adhuc protulisti, popularia sunt, ego autem a te elegantiora desidero. Duo Reges: constructio interrete. Tum Lucius: Mihi vero ista valde probata sunt, quod item fratri puto. Bestiarum vero nullum iudicium puto. Nihil enim iam habes, quod ad corpus referas  Deinde prima illa, quae in congressu solemus: Quid tu, inquit, huc? Et homini, qui ceteris animantibus plurimum praestat, praecipue a natura nihil datum esse dicemus? Iam id ipsum absurdum, maximum malum neglegi. Quod ea non occurrentia fingunt, vincunt Aristonem  Atqui perspicuum est hominem e corpore animoque constare, cum primae sint animi partes, secundae corporis. Fieri, inquam, Triari, nullo pacto potest, ut non dicas, quid non probes eius, a quo dissentias. Equidem e Cn. An dubium est, quin virtus ita maximam partem optineat in rebus humanis, ut reliquas obruat? Quis istum dolorem timet? Summus dolor plures dies manere non potest? Dicet pro me ipsa virtus nec dubitabit isti vestro beato M. Tubulum fuisse, qua illum, cuius is condemnatus est rogatione, P. Quod si ita sit, cur opera philosophiae sit danda nescio. Ex eorum enim scriptis et institutis cum omnis doctrina liberalis, omnis historia. Quod si ita est, sequitur id ipsum, quod te velle video, omnes semper beatos esse sapientes. Cum enim fertur quasi torrens oratio, quamvis multa cuiusque modi rapiat, nihil tamen teneas, nihil apprehendas, nusquam orationem rapidam coerceas. Ita redarguitur ipse a sese, convincunturque scripta eius probitate ipsius ac moribus. At quanta conantur! Mundum hunc omnem oppidum esse nostrum! Incendi igitur eos, qui audiunt, vides. Vide, ne magis, inquam, tuum fuerit, cum re idem tibi, quod mihi, videretur, non nova te rebus nomina inponere. Qui-vere falsone, quaerere mittimus-dicitur oculis se privasse  Si ista mala sunt, in quae potest incidere sapiens, sapientem esse non esse ad beate vivendum satis. At vero si ad vitem sensus accesserit, ut appetitum quendam habeat et per se ipsa moveatur, quid facturam putas? Quem si tenueris, non modo meum Ciceronem, sed etiam me ipsum abducas licebit. Stulti autem malorum memoria torquentur, sapientes bona praeterita grata recordatione renovata delectant. Esse enim quam vellet iniquus iustus poterat inpune. Quae autem natura suae primae institutionis oblita est? Verum tamen cum de rebus grandioribus dicas, ipsae res verba rapiunt  Hoc est non modo cor non habere, sed ne palatum quidem. Voluptatem cum summum bonum diceret, primum in eo ipso parum vidit, deinde hoc quoque alienum  Sed tu istuc dixti bene Latine, parum plane. Nam haec ipsa mihi erunt in promptu, quae modo audivi, nec ante aggrediar, quam te ab istis, quos dicis, instructum videro. Fatebuntur Stoici haec omnia dicta esse praeclare, neque eam causam Zenoni desciscendi fuisse. Non autem hoc: igitur ne illud quidem. Ratio quidem vestra sic cogit. Cum audissem Antiochum, Brute, ut solebam, cum M. An quod ita callida est, ut optime possit architectari voluptates? Idemne, quod iucunde? Haec mihi videtur delicatior, ut ita dicam, molliorque ratio, quam virtutis vis gravitasque postulat. Sed quoniam et advesperascit et mihi ad villam revertendum est, nunc quidem hactenus  Cuius ad naturam apta ratio vera illa et summa lex a philosophis dicitur. Neque solum ea communia, verum etiam paria esse dixerunt. Sed nunc, quod agimus  A mene tu?';
        EmailService_TestUtils.loadEmailSettingsSTE();
        EmailService_TestUtils.loadFiltersSTE();
        final EmailServiceSTE emailservengSTE = new EmailServiceSTE();
        final Messaging.InboundEmailResult result = emailservengSTE.handleInboundEmail(email,envelope);
        system.assertnotEquals(result,null);
    }
    @isTest
    /*-------------------------------------------------------------------------------
    Description:   Method that executes the creation of two emails with two filters (STE).
    ---------------------------------------------------------------------------------*/
    public static void fullFlowDoubleToAddressTwoFilters() {
        EmailService_TestUtils.bypassall();
        final Messaging.InboundEmail email = new Messaging.InboundEmail();
        final Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        envelope.fromAddress = FROM_ADD;
        envelope.toaddress = EMAIL_RULE;
        final List<Messaging.InboundEmail.Header> headers = new List<Messaging.InboundEmail.Header>();
        final Messaging.InboundEmail.Header messageid = new Messaging.InboundEmail.Header();
        messageid.name = 'Message-ID6';
        messageid.value = 'messageid6';
        headers.add(messageid);
        email.fromAddress = FROM_ADD;
        email.headers = headers;
        email.subject = 'Subject2';
        email.htmlBody = 'Quod equidem non reprehendo Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quibus natura iure responderit non esse verum aliunde finem beate vivendi, a se principia rei gerendae peti  Quae enim adhuc protulisti, popularia sunt, ego autem a te elegantiora desidero. Duo Reges: constructio interrete. Tum Lucius: Mihi vero ista valde probata sunt, quod item fratri puto. Bestiarum vero nullum iudicium puto. Nihil enim iam habes, quod ad corpus referas  Deinde prima illa, quae in congressu solemus: Quid tu, inquit, huc? Et homini, qui ceteris animantibus plurimum praestat, praecipue a natura nihil datum esse dicemus? Iam id ipsum absurdum, maximum malum neglegi. Quod ea non occurrentia fingunt, vincunt Aristonem  Atqui perspicuum est hominem e corpore animoque constare, cum primae sint animi partes, secundae corporis. Fieri, inquam, Triari, nullo pacto potest, ut non dicas, quid non probes eius, a quo dissentias. Equidem e Cn. An dubium est, quin virtus ita maximam partem optineat in rebus humanis, ut reliquas obruat?mQuis istum dolorem timet? Summus dolor plures dies manere non potest? Dicet pro me ipsa virtus nec dubitabit isti vestro beato M. Tubulum fuisse, qua illum, cuius is condemnatus est rogatione, P. Quod si ita sit, cur opera philosophiae sit danda nescio. Ex eorum enim scriptis et institutis cum omnis doctrina liberalis, omnis historia. Quod si ita est, sequitur id ipsum, quod te velle video, omnes semper beatos esse sapientes. Cum enim fertur quasi torrens oratio, quamvis multa cuiusque modi rapiat, nihil tamen teneas, nihil apprehendas, nusquam orationem rapidam coerceas. Ita redarguitur ipse a sese, convincunturque scripta eius probitate ipsius ac moribus. At quanta conantur! Mundum hunc omnem oppidum esse nostrum! Incendi igitur eos, qui audiunt, vides. Vide, ne magis, inquam, tuum fuerit, cum re idem tibi, quod mihi, videretur, non nova te rebus nomina inponere. Qui-vere falsone, quaerere mittimus-dicitur oculis se privasse  Si ista mala sunt, in quae potest incidere sapiens, sapientem esse non esse ad beate vivendum satis. At vero si ad vitem sensus accesserit, ut appetitum quendam habeat et per se ipsa moveatur, quid facturam putas? Quem si tenueris, non modo meum Ciceronem, sed etiam me ipsum abducas licebit. Stulti autem malorum memoria torquentur, sapientes bona praeterita grata recordatione renovata delectant.Esse enim quam vellet iniquus iustus poterat inpune. Quae autem natura suae primae institutionis oblita est Verum tamen cum de rebus grandioribus dicas, ipsae res verba rapiunt  Hoc est non modo cor non habere, sed ne palatum quidem. Voluptatem cum summum bonum diceret, primum in eo ipso parum vidit, deinde hoc quoque alienum  Sed tu istuc dixti bene Latine, parum plane. Nam haec ipsa mihi erunt in promptu, quae modo audivi, nec ante aggrediar, quam te ab istis, quos dicis, instructum videro. Fatebuntur Stoici haec omnia dicta esse praeclare, neque eam causam Zenoni desciscendi fuisse. Non autem hoc: igitur ne illud quidem. Ratio quidem vestra sic cogit. Cum audissem Antiochum, Brute, ut solebam, cum M. An quod ita callida est, ut optime possit architectari voluptates? Idemne, quod iucunde? Haec mihi videtur delicatior, ut ita dicam, molliorque ratio, quam virtutis vis gravitasque postulat. Sed quoniam et advesperascit et mihi ad villam revertendum est, nunc quidem hactenus  Cuius ad naturam apta ratio vera illa et summa lex a philosophis dicitur. Neque solum ea communia, verum etiam paria esse dixerunt. Sed nunc, quod agimus  A mene tu? Quod equidem non reprehendo  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quibus natura iure responderit non esse verum aliunde finem beate vivendi, a se principia rei gerendae peti  Quae enim adhuc protulisti, popularia sunt, ego autem a te elegantiora desidero. Duo Reges: constructio interrete. Tum Lucius: Mihi vero ista valde probata sunt, quod item fratri puto. Bestiarum vero nullum iudicium puto. Nihil enim iam habes, quod ad corpus referas  Deinde prima illa, quae in congressu solemus: Quid tu, inquit, huc? Et homini, qui ceteris animantibus plurimum praestat, praecipue a natura nihil datum esse dicemus? Iam id ipsum absurdum, maximum malum neglegi. Quod ea non occurrentia fingunt, vincunt Aristonem  Atqui perspicuum est hominem e corpore animoque constare, cum primae sint animi partes, secundae corporis. Fieri, inquam, Triari, nullo pacto potest, ut non dicas, quid non probes eius, a quo dissentias. Equidem e Cn. An dubium est, quin virtus ita maximam partem optineat in rebus humanis, ut reliquas obruat? Quis istum dolorem timet? Summus dolor plures dies manere non potest? Dicet pro me ipsa virtus nec dubitabit isti vestro beato M. Tubulum fuisse, qua illum, cuius is condemnatus est rogatione, P. Quod si ita sit, cur opera philosophiae sit danda nescio. Ex eorum enim scriptis et institutis cum omnis doctrina liberalis, omnis historia. Quod si ita est, sequitur id ipsum, quod te velle video, omnes semper beatos esse sapientes. Cum enim fertur quasi torrens oratio, quamvis multa cuiusque modi rapiat, nihil tamen teneas, nihil apprehendas, nusquam orationem rapidam coerceas. Ita redarguitur ipse a sese, convincunturque scripta eius probitate ipsius ac moribus. At quanta conantur! Mundum hunc omnem oppidum esse nostrum! Incendi igitur eos, qui audiunt, vides. Vide, ne magis, inquam, tuum fuerit, cum re idem tibi, quod mihi, videretur, non nova te rebus nomina inponere. Qui-vere falsone, quaerere mittimus-dicitur oculis se privasse  Si ista mala sunt, in quae potest incidere sapiens, sapientem esse non esse ad beate vivendum satis. At vero si ad vitem sensus accesserit, ut appetitum quendam habeat et per se ipsa moveatur, quid facturam putas? Quem si tenueris, non modo meum Ciceronem, sed etiam me ipsum abducas licebit. Stulti autem malorum memoria torquentur, sapientes bona praeterita grata recordatione renovata delectant. Esse enim quam vellet iniquus iustus poterat inpune. Quae autem natura suae primae institutionis oblita est? Verum tamen cum de rebus grandioribus dicas, ipsae res verba rapiunt  Hoc est non modo cor non habere, sed ne palatum quidem. Voluptatem cum summum bonum diceret, primum in eo ipso parum vidit, deinde hoc quoque alienum  Sed tu istuc dixti bene Latine, parum plane. Nam haec ipsa mihi erunt in promptu, quae modo audivi, nec ante aggrediar, quam te ab istis, quos dicis, instructum videro. Fatebuntur Stoici haec omnia dicta esse praeclare, neque eam causam Zenoni desciscendi fuisse. Non autem hoc: igitur ne illud quidem. Ratio quidem vestra sic cogit. Cum audissem Antiochum, Brute, ut solebam, cum M. An quod ita callida est, ut optime possit architectari voluptates? Idemne, quod iucunde? Haec mihi videtur delicatior, ut ita dicam, molliorque ratio, quam virtutis vis gravitasque postulat. Sed quoniam et advesperascit et mihi ad villam revertendum est, nunc quidem hactenus  Cuius ad naturam apta ratio vera illa et summa lex a philosophis dicitur. Neque solum ea communia, verum etiam paria esse dixerunt. Sed nunc, quod agimus  A mene tu?';
        email.plainTextBody = 'Quod equidem non reprehendo Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quibus natura iure responderit non esse verum aliunde finem beate vivendi, a se principia rei gerendae peti  Quae enim adhuc protulisti, popularia sunt, ego autem a te elegantiora desidero. Duo Reges: constructio interrete. Tum Lucius: Mihi vero ista valde probata sunt, quod item fratri puto. Bestiarum vero nullum iudicium puto. Nihil enim iam habes, quod ad corpus referas  Deinde prima illa, quae in congressu solemus: Quid tu, inquit, huc? Et homini, qui ceteris animantibus plurimum praestat, praecipue a natura nihil datum esse dicemus? Iam id ipsum absurdum, maximum malum neglegi. Quod ea non occurrentia fingunt, vincunt Aristonem  Atqui perspicuum est hominem e corpore animoque constare, cum primae sint animi partes, secundae corporis. Fieri, inquam, Triari, nullo pacto potest, ut non dicas, quid non probes eius, a quo dissentias. Equidem e Cn. An dubium est, quin virtus ita maximam partem optineat in rebus humanis, ut reliquas obruat?mQuis istum dolorem timet? Summus dolor plures dies manere non potest? Dicet pro me ipsa virtus nec dubitabit isti vestro beato M. Tubulum fuisse, qua illum, cuius is condemnatus est rogatione, P. Quod si ita sit, cur opera philosophiae sit danda nescio. Ex eorum enim scriptis et institutis cum omnis doctrina liberalis, omnis historia. Quod si ita est, sequitur id ipsum, quod te velle video, omnes semper beatos esse sapientes. Cum enim fertur quasi torrens oratio, quamvis multa cuiusque modi rapiat, nihil tamen teneas, nihil apprehendas, nusquam orationem rapidam coerceas. Ita redarguitur ipse a sese, convincunturque scripta eius probitate ipsius ac moribus. At quanta conantur! Mundum hunc omnem oppidum esse nostrum! Incendi igitur eos, qui audiunt, vides. Vide, ne magis, inquam, tuum fuerit, cum re idem tibi, quod mihi, videretur, non nova te rebus nomina inponere. Qui-vere falsone, quaerere mittimus-dicitur oculis se privasse  Si ista mala sunt, in quae potest incidere sapiens, sapientem esse non esse ad beate vivendum satis. At vero si ad vitem sensus accesserit, ut appetitum quendam habeat et per se ipsa moveatur, quid facturam putas? Quem si tenueris, non modo meum Ciceronem, sed etiam me ipsum abducas licebit. Stulti autem malorum memoria torquentur, sapientes bona praeterita grata recordatione renovata delectant.Esse enim quam vellet iniquus iustus poterat inpune. Quae autem natura suae primae institutionis oblita est Verum tamen cum de rebus grandioribus dicas, ipsae res verba rapiunt  Hoc est non modo cor non habere, sed ne palatum quidem. Voluptatem cum summum bonum diceret, primum in eo ipso parum vidit, deinde hoc quoque alienum  Sed tu istuc dixti bene Latine, parum plane. Nam haec ipsa mihi erunt in promptu, quae modo audivi, nec ante aggrediar, quam te ab istis, quos dicis, instructum videro. Fatebuntur Stoici haec omnia dicta esse praeclare, neque eam causam Zenoni desciscendi fuisse. Non autem hoc: igitur ne illud quidem. Ratio quidem vestra sic cogit. Cum audissem Antiochum, Brute, ut solebam, cum M. An quod ita callida est, ut optime possit architectari voluptates? Idemne, quod iucunde? Haec mihi videtur delicatior, ut ita dicam, molliorque ratio, quam virtutis vis gravitasque postulat. Sed quoniam et advesperascit et mihi ad villam revertendum est, nunc quidem hactenus  Cuius ad naturam apta ratio vera illa et summa lex a philosophis dicitur. Neque solum ea communia, verum etiam paria esse dixerunt. Sed nunc, quod agimus  A mene tu? Quod equidem non reprehendo  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quibus natura iure responderit non esse verum aliunde finem beate vivendi, a se principia rei gerendae peti  Quae enim adhuc protulisti, popularia sunt, ego autem a te elegantiora desidero. Duo Reges: constructio interrete. Tum Lucius: Mihi vero ista valde probata sunt, quod item fratri puto. Bestiarum vero nullum iudicium puto. Nihil enim iam habes, quod ad corpus referas  Deinde prima illa, quae in congressu solemus: Quid tu, inquit, huc? Et homini, qui ceteris animantibus plurimum praestat, praecipue a natura nihil datum esse dicemus? Iam id ipsum absurdum, maximum malum neglegi. Quod ea non occurrentia fingunt, vincunt Aristonem  Atqui perspicuum est hominem e corpore animoque constare, cum primae sint animi partes, secundae corporis. Fieri, inquam, Triari, nullo pacto potest, ut non dicas, quid non probes eius, a quo dissentias. Equidem e Cn. An dubium est, quin virtus ita maximam partem optineat in rebus humanis, ut reliquas obruat? Quis istum dolorem timet? Summus dolor plures dies manere non potest? Dicet pro me ipsa virtus nec dubitabit isti vestro beato M. Tubulum fuisse, qua illum, cuius is condemnatus est rogatione, P. Quod si ita sit, cur opera philosophiae sit danda nescio. Ex eorum enim scriptis et institutis cum omnis doctrina liberalis, omnis historia. Quod si ita est, sequitur id ipsum, quod te velle video, omnes semper beatos esse sapientes. Cum enim fertur quasi torrens oratio, quamvis multa cuiusque modi rapiat, nihil tamen teneas, nihil apprehendas, nusquam orationem rapidam coerceas. Ita redarguitur ipse a sese, convincunturque scripta eius probitate ipsius ac moribus. At quanta conantur! Mundum hunc omnem oppidum esse nostrum! Incendi igitur eos, qui audiunt, vides. Vide, ne magis, inquam, tuum fuerit, cum re idem tibi, quod mihi, videretur, non nova te rebus nomina inponere. Qui-vere falsone, quaerere mittimus-dicitur oculis se privasse  Si ista mala sunt, in quae potest incidere sapiens, sapientem esse non esse ad beate vivendum satis. At vero si ad vitem sensus accesserit, ut appetitum quendam habeat et per se ipsa moveatur, quid facturam putas? Quem si tenueris, non modo meum Ciceronem, sed etiam me ipsum abducas licebit. Stulti autem malorum memoria torquentur, sapientes bona praeterita grata recordatione renovata delectant. Esse enim quam vellet iniquus iustus poterat inpune. Quae autem natura suae primae institutionis oblita est? Verum tamen cum de rebus grandioribus dicas, ipsae res verba rapiunt  Hoc est non modo cor non habere, sed ne palatum quidem. Voluptatem cum summum bonum diceret, primum in eo ipso parum vidit, deinde hoc quoque alienum  Sed tu istuc dixti bene Latine, parum plane. Nam haec ipsa mihi erunt in promptu, quae modo audivi, nec ante aggrediar, quam te ab istis, quos dicis, instructum videro. Fatebuntur Stoici haec omnia dicta esse praeclare, neque eam causam Zenoni desciscendi fuisse. Non autem hoc: igitur ne illud quidem. Ratio quidem vestra sic cogit. Cum audissem Antiochum, Brute, ut solebam, cum M. An quod ita callida est, ut optime possit architectari voluptates? Idemne, quod iucunde? Haec mihi videtur delicatior, ut ita dicam, molliorque ratio, quam virtutis vis gravitasque postulat. Sed quoniam et advesperascit et mihi ad villam revertendum est, nunc quidem hactenus  Cuius ad naturam apta ratio vera illa et summa lex a philosophis dicitur. Neque solum ea communia, verum etiam paria esse dixerunt. Sed nunc, quod agimus  A mene tu?';
        email.toAddresses = new List<String>{EMAIL_RULE,EMAIL_RULE};
        EmailService_TestUtils.loadEmailSettingsSTE();
        EmailService_TestUtils.loadFiltersSTE();
        EmailService_TestUtils.loadFilters2STE();
        final EmailServiceSTE emailservengSTE = new EmailServiceSTE();   
        final Messaging.InboundEmailResult result = emailservengSTE.handleInboundEmail(email,envelope);
        system.assertnotEquals(result,null);
    }
    @isTest
    /*-------------------------------------------------------------------------------
    Description:   Method that executes the creation of an email with attachments >4Kbs & Content Type(STE)
    ---------------------------------------------------------------------------------*/ 
    public static void fullFlowSingleAddressUniqueFilterWithAttachmentsPlusKbContentTypeSTE() {
        EmailService_TestUtils.bypassall();
        final Messaging.InboundEmail email = new Messaging.InboundEmail();
        final Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        envelope.fromAddress = FROM_EMAIL;
        envelope.toaddress = FROM_7;
        final List<Messaging.InboundEmail.Header> headers = new List<Messaging.InboundEmail.Header>();
        final Messaging.InboundEmail.Header messageid = new Messaging.InboundEmail.Header();
        final Messaging.InboundEmail.Header contenttype = new Messaging.InboundEmail.Header();
        contenttype.name = CONTENT_TYPE;
        contenttype.value = TEXT;
        messageid.name = 'Message-ID7';
        messageid.value = 'messageid7';
        headers.add(messageid);
        headers.add(contenttype);
        email.fromAddress = FROM_EMAIL;
        email.headers = headers;
        email.subject = SUBJECT;
        email.htmlBody = 'htmlbody7';
        email.plainTextBody = PLAIN_TEXT;
        EmailService_TestUtils.loadEmailSettingsSTE();
        EmailService_TestUtils.loadFiltersSTE();
        //BinaryAttachments
        email.binaryattachments = new List<Messaging.InboundEmail.BinaryAttachment>{EmailService_TestUtilsSTE.binaryAttPlus4kbContentTypeSTE()};
        //TextAttachments
        email.textAttachments = new List<Messaging.InboundEmail.TextAttachment>{EmailService_TestUtilsSTE.textAttSTE()};
        final EmailServiceSTE emailservengSTE = new EmailServiceSTE();  
        final Messaging.InboundEmailResult result = emailservengSTE.handleInboundEmail(email,envelope);
        system.assertnotEquals(result,null);
    }
    
    @isTest
    /*-------------------------------------------------------------------------------
    Description:   Method that executes the creation of an email with attachments >4Kbs & Content Type Without Header (STE)
    ---------------------------------------------------------------------------------*/ 
    public static void fullFlowSingleAddressUniqueFilterWithAttachmentsPlusKbContentTypeNoHeaderSTE() {
        EmailService_TestUtils.bypassall();
        final Messaging.InboundEmail email = new Messaging.InboundEmail();
        final Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        envelope.fromAddress = FROM_EMAIL;
        envelope.toaddress = FROM_7;
        final Messaging.InboundEmail.Header messageid = new Messaging.InboundEmail.Header();
        final Messaging.InboundEmail.Header contenttype = new Messaging.InboundEmail.Header();
        contenttype.name = CONTENT_TYPE;
        contenttype.value = TEXT;
        messageid.name = 'Message-ID7';
        messageid.value = 'messageid7';
        email.fromAddress = FROM_EMAIL;
        email.subject = SUBJECT;
        email.htmlBody = 'htmlbody7';
        email.plainTextBody = PLAIN_TEXT;
        EmailService_TestUtils.loadEmailSettingsSTE();
        EmailService_TestUtils.loadFiltersSTE();
        //BinaryAttachments
        email.binaryattachments = new List<Messaging.InboundEmail.BinaryAttachment>{EmailService_TestUtilsSTE.binaryAttPlus4kbContentTypeSTE()};
        //TextAttachments
        email.textAttachments = new List<Messaging.InboundEmail.TextAttachment>{EmailService_TestUtilsSTE.textAttSTE()};
        final EmailServiceSTE emailservengSTE = new EmailServiceSTE();  
        final Messaging.InboundEmailResult result = emailservengSTE.handleInboundEmail(email,envelope);
        system.assertnotEquals(result,null);
    }
    @isTest
    /*-------------------------------------------------------------------------------
    Description:   Method that executes the creation of an email with attachments <4Kbs & Content Type(STE)
    ---------------------------------------------------------------------------------*/ 
    public static void fullFlowSingleAddressUniqueFilterWithAttachmentsMinusKbSTE() {
        EmailService_TestUtils.bypassall();
        final Messaging.InboundEmail email = new Messaging.InboundEmail();
        final Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        envelope.fromAddress = FROM_EMAIL;
        envelope.toaddress = FROM_7;
        final List<Messaging.InboundEmail.Header> headers = new List<Messaging.InboundEmail.Header>();
        final Messaging.InboundEmail.Header messageid = new Messaging.InboundEmail.Header();
        messageid.name = 'Message-ID7';
        messageid.value = 'messageid7';
        headers.add(messageid);
        email.fromAddress = FROM_EMAIL;
        email.headers = headers;
        email.subject = SUBJECT;
        email.htmlBody = 'htmlbody7';
        email.plainTextBody = PLAIN_TEXT;
        EmailService_TestUtils.loadEmailSettingsSTE();
        EmailService_TestUtils.loadFiltersSTE();
        //BinaryAttachments
        email.binaryattachments = new List<Messaging.InboundEmail.BinaryAttachment>{EmailService_TestUtilsSTE.binaryAttMinus4kbSTE()};
        //TextAttachments
        email.textAttachments = new List<Messaging.InboundEmail.TextAttachment>{EmailService_TestUtilsSTE.textAttSTE()};
        final EmailServiceSTE emailservengSTE = new EmailServiceSTE();  
        final Messaging.InboundEmailResult result = emailservengSTE.handleInboundEmail(email,envelope);
        system.assertnotEquals(result,null);
    }
    @isTest
    /*-------------------------------------------------------------------------------
    Description:   Method that executes the creation of email duplicity STE.
    ---------------------------------------------------------------------------------*/ 
    public static void fullFlowDuplicitySTE() {
        EmailService_TestUtils.bypassall();
        final Messaging.InboundEmail email = new Messaging.InboundEmail();
        final Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        envelope.fromAddress = 'fromaddressSTE@email.com';
        envelope.toaddress = 'FromSTE';
        final List<Messaging.InboundEmail.Header> headers = new List<Messaging.InboundEmail.Header>();
        final Messaging.InboundEmail.Header messageid = new Messaging.InboundEmail.Header();
        messageid.name = 'Message-IDSTE';
        messageid.value = 'messageidSTE';
        headers.add(messageid);
        email.fromAddress = 'fromaddressSTE@email.com';
        email.headers = headers;
        email.subject = 'SubjectSTE';
        email.htmlBody = 'htmlbodySTE'; 
        email.plainTextBody = 'plaintextbodySTE';
        EmailService_TestUtils.loadEmailSettingsSTE();
        EmailService_TestUtils.loadFiltersSTE();
        final EmailServiceSTE emailservengSTE = new EmailServiceSTE();  
        final Messaging.InboundEmailResult result = emailservengSTE.handleInboundEmail(email,envelope);
        final Messaging.InboundEmailResult result2 = emailservengSTE.handleInboundEmail(email,envelope);
        system.assertnotEquals(result,null);
        system.assertnotEquals(result2,null);
    }
    @isTest
    /*-------------------------------------------------------------------------------
    Description:   Method testgenericex for EGS & GM & STE.
    ---------------------------------------------------------------------------------*/ 
    public static void testgenericex() {
        EmailService_TestUtils.bypassall();
        final EmailServiceSTE emailServSngSTE = new EmailServiceSTE();

        final Messaging.InboundEmailResult result = emailServSngSTE.handleInboundEmail(New Messaging.InboundEmail(), null);
        system.assertnotEquals(result,null);
    }

}