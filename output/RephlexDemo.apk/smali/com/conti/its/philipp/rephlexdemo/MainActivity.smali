.class public Lcom/conti/its/philipp/rephlexdemo/MainActivity;
.super Landroid/support/v7/app/AppCompatActivity;
.source "MainActivity.java"


# static fields
.field public static final TAG:Ljava/lang/String; = "RephlexDemo"


# instance fields
.field private btnLogin:Landroid/widget/Button;

.field private inpPw:Landroid/widget/EditText;


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 12
    invoke-direct {p0}, Landroid/support/v7/app/AppCompatActivity;-><init>()V

    return-void
.end method

.method static synthetic access$000(Lcom/conti/its/philipp/rephlexdemo/MainActivity;)Landroid/widget/EditText;
    .locals 1
    .param p0, "x0"    # Lcom/conti/its/philipp/rephlexdemo/MainActivity;

    .prologue
    .line 12
    iget-object v0, p0, Lcom/conti/its/philipp/rephlexdemo/MainActivity;->inpPw:Landroid/widget/EditText;

    return-object v0
.end method


# virtual methods
.method protected onCreate(Landroid/os/Bundle;)V
    .locals 2
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .prologue
    .line 21
    invoke-super {p0, p1}, Landroid/support/v7/app/AppCompatActivity;->onCreate(Landroid/os/Bundle;)V

    .line 22
    const v0, 0x7f04001a

    invoke-virtual {p0, v0}, Lcom/conti/its/philipp/rephlexdemo/MainActivity;->setContentView(I)V

    .line 24
    const v0, 0x7f0b0056

    invoke-virtual {p0, v0}, Lcom/conti/its/philipp/rephlexdemo/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/EditText;

    iput-object v0, p0, Lcom/conti/its/philipp/rephlexdemo/MainActivity;->inpPw:Landroid/widget/EditText;

    .line 26
    const v0, 0x7f0b0057

    invoke-virtual {p0, v0}, Lcom/conti/its/philipp/rephlexdemo/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/Button;

    iput-object v0, p0, Lcom/conti/its/philipp/rephlexdemo/MainActivity;->btnLogin:Landroid/widget/Button;

    .line 27
    iget-object v0, p0, Lcom/conti/its/philipp/rephlexdemo/MainActivity;->btnLogin:Landroid/widget/Button;

    new-instance v1, Lcom/conti/its/philipp/rephlexdemo/MainActivity$1;

    invoke-direct {v1, p0}, Lcom/conti/its/philipp/rephlexdemo/MainActivity$1;-><init>(Lcom/conti/its/philipp/rephlexdemo/MainActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 46
    return-void
.end method
