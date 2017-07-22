.class Lcom/conti/its/philipp/rephlexdemo/MainActivity$1;
.super Ljava/lang/Object;
.source "MainActivity.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/conti/its/philipp/rephlexdemo/MainActivity;->onCreate(Landroid/os/Bundle;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/conti/its/philipp/rephlexdemo/MainActivity;


# direct methods
.method constructor <init>(Lcom/conti/its/philipp/rephlexdemo/MainActivity;)V
    .locals 0
    .param p1, "this$0"    # Lcom/conti/its/philipp/rephlexdemo/MainActivity;

    .prologue
    .line 27
    iput-object p1, p0, Lcom/conti/its/philipp/rephlexdemo/MainActivity$1;->this$0:Lcom/conti/its/philipp/rephlexdemo/MainActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 8
    .param p1, "v"    # Landroid/view/View;

    .prologue
    .line 30
    iget-object v3, p0, Lcom/conti/its/philipp/rephlexdemo/MainActivity$1;->this$0:Lcom/conti/its/philipp/rephlexdemo/MainActivity;

    # getter for: Lcom/conti/its/philipp/rephlexdemo/MainActivity;->inpPw:Landroid/widget/EditText;
    invoke-static {v3}, Lcom/conti/its/philipp/rephlexdemo/MainActivity;->access$000(Lcom/conti/its/philipp/rephlexdemo/MainActivity;)Landroid/widget/EditText;

    move-result-object v3

    invoke-virtual {v3}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    .line 31
    .local v0, "input":Ljava/lang/String;
    new-instance v2, Lcom/conti/its/philipp/rephlexdemo/LoginVerifier;

    invoke-direct {v2}, Lcom/conti/its/philipp/rephlexdemo/LoginVerifier;-><init>()V

    .line 32

    invoke-static {v2}, Lcom/conti/its/philipp/rephlexdemo/LoginVerifier;->getInstance(Lcom/conti/its/philipp/rephlexdemo/LoginVerifier;)Lcom/conti/its/philipp/rephlexdemo/LoginVerifier;

    move-result-object v7
    .local v2, "verifier":Lcom/conti/its/philipp/rephlexdemo/LoginVerifier;
    invoke-virtual {v7, v0}, Lcom/conti/its/philipp/rephlexdemo/LoginVerifier;->verifyLogin(Ljava/lang/String;)Z

    move-result v1

    .line 34
    .local v1, "isValid":Z
    if-eqz v1, :cond_0

    .line 35
    const-string v3, "RephlexDemo"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Correct password, input was >"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "< and correct password is"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, ">"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 36
    invoke-virtual {v2}, Lcom/conti/its/philipp/rephlexdemo/LoginVerifier;->getPassword()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "<"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 35
    invoke-static {v3, v4}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 37
    iget-object v3, p0, Lcom/conti/its/philipp/rephlexdemo/MainActivity$1;->this$0:Lcom/conti/its/philipp/rephlexdemo/MainActivity;

    new-instance v4, Landroid/content/Intent;

    iget-object v5, p0, Lcom/conti/its/philipp/rephlexdemo/MainActivity$1;->this$0:Lcom/conti/its/philipp/rephlexdemo/MainActivity;

    invoke-virtual {v5}, Lcom/conti/its/philipp/rephlexdemo/MainActivity;->getApplicationContext()Landroid/content/Context;

    move-result-object v5

    const-class v6, Lcom/conti/its/philipp/rephlexdemo/WelcomeActivity;

    invoke-direct {v4, v5, v6}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {v3, v4}, Lcom/conti/its/philipp/rephlexdemo/MainActivity;->startActivity(Landroid/content/Intent;)V

    .line 44
    :goto_0
    return-void

    .line 39
    :cond_0
    const-string v3, "RephlexDemo"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Incorrect password, input was >"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "< and correct password "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "is >"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 40
    invoke-virtual {v2}, Lcom/conti/its/philipp/rephlexdemo/LoginVerifier;->getPassword()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "<"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 39
    invoke-static {v3, v4}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 41
    iget-object v3, p0, Lcom/conti/its/philipp/rephlexdemo/MainActivity$1;->this$0:Lcom/conti/its/philipp/rephlexdemo/MainActivity;

    invoke-virtual {v3}, Lcom/conti/its/philipp/rephlexdemo/MainActivity;->getApplicationContext()Landroid/content/Context;

    move-result-object v3

    const-string v4, "Incorrect password! Try again."

    const/4 v5, 0x1

    invoke-static {v3, v4, v5}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v3

    .line 42
    invoke-virtual {v3}, Landroid/widget/Toast;->show()V

    goto :goto_0
.end method
