<?php

class Product
{
    private $_name;
    private $price;
    public function __construct(NameInterface $name, PriceInterface $price) {
        $this->name = $name->getName();
        $this->price = $price->getPrice();
    }
    public function getName()
    {
        return $this->name;
    }
    public function getPrice()
    {
        return $this->price;
    }
}

interface NameInterface
{
    public function getName(): string;
}

interface PriceInterface
{
    public function getPrice(): float;
}

class Name implements NameInterface
{
    public function getName(): string
    {
        return 'test';
    }
}
class Price implements PriceInterface
{
    public function getPrice(): float
    {
        return 1234.5;
    }
}

// プロパティのインスタンスか
$name = new Name();
$price = new Price();

$product = new Product($name, $price);

echo "インスタンス化の結果" . PHP_EOL;
echo $product->getPrice() . PHP_EOL;
echo "インスタンス化の結果終わり" . PHP_EOL;
