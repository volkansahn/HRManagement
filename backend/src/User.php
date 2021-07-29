<?php

namespace Src;

class User
{

    private $db = null;

    public function __construct($db)
    {
        $this->db = $db;
    }

    public function findAll()
    {
        $statement = "
            SELECT 
                *
            FROM
                kullanici;
        ";

        try {
            $statement = $this->db->query($statement);
            $result = $statement->fetchAll(\PDO::FETCH_ASSOC);
            return $result;
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function find($kullanici_id)
    {
        $statement = "
            SELECT 
                *
            FROM
                kullanici
            WHERE kullanici_id = :kullanici_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'kullanici_id' => $kullanici_id
            ));
            $result = $statement->fetchAll(\PDO::FETCH_ASSOC);
            return $result;
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function findByRole($rol_id)
    {
        $statement = "
            SELECT 
                *
            FROM
                kullanici
            WHERE rol_id = :rol_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'rol_id' => $rol_id
            ));
            $result = $statement->fetchAll(\PDO::FETCH_ASSOC);
            return $result;
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function insert(array $input)
    {
        $statement = "
            INSERT INTO kullanici 
                (kullanici_id, adi, soyadi, sifre, rol_id)
            VALUES
                (:kullanici_id, :adi, :soyadi, :sifre, :rol_id);
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'kullanici_id' => $input['kullanici_id'],
                'adi' => $input['adi'],
                'soyadi' => $input['soyadi'],
                'sifre' => $input['sifre'],
                'rol_id' => $input['rol_id']
            ));
            return $statement->rowCount();
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function update($kullanici_id, array $input)
    {
        $statement = "
            UPDATE kullanici
            SET 
                adi = :adi,
                soyadi  = :soyadi,
                rol_id = :rol_id
            WHERE kullanici_id = :kullanici_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'kullanici_id' => $kullanici_id,
                'adi' => $input['adi'],
                'soyadi' => $input['soyadi'],
                'rol_id' => $input['rol_id']
            ));
            return $statement->rowCount();
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function delete($kullanici_id)
    {
        $statement = "
            DELETE FROM kullanici
            WHERE kullanici_id = :kullanici_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array('kullanici_id' => $kullanici_id));
            return $statement->rowCount();
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }
}