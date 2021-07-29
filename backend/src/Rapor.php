<?php


namespace Src;


class Rapor
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
                rapor;
        ";

        try {
            $statement = $this->db->query($statement);
            $result = $statement->fetchAll(\PDO::FETCH_ASSOC);
            return $result;
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function find($rapor_id)
    {
        $statement = "
            SELECT 
                *
            FROM
                rapor
            WHERE rapor_id = :rapor_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'rapor_id' => $rapor_id
            ));
            $result = $statement->fetchAll(\PDO::FETCH_ASSOC);
            return $result;
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function findBekler($bekler_id)
    {
        $statement = "
            SELECT 
                *
            FROM
                rapor
            WHERE bekler_id = :bekler_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'bekler_id' => $bekler_id
            ));
            $result = $statement->fetchAll(\PDO::FETCH_ASSOC);
            return $result;
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function findByUser($kullanici_id)
    {
        $statement = "
            SELECT 
                *
            FROM
                rapor
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

    public function insert(array $input)
    {
        $statement = "
            INSERT INTO rapor 
                (kullanici_id, rapor_tarihi, nedeni, rapor_baslangic, rapor_bitis, durum_id, bekler_id)
            VALUES
                (:kullanici_id, :rapor_tarihi, :nedeni, :rapor_baslangic, :rapor_bitis, :durum_id, :bekler_id);
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'kullanici_id' => $input['kullanici_id'],
                'rapor_tarihi' => $input['rapor_tarihi'],
                'nedeni' => $input['nedeni'],
                'rapor_baslangic' => $input['rapor_baslangic'],
                'rapor_bitis' => $input['rapor_bitis'],
                'durum_id' => $input['durum_id'],
                'bekler_id' => $input['bekler_id']
            ));
            return $statement->rowCount();
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function update($rapor_id, array $input)
    {
        $statement = "
            UPDATE rapor
            SET 
                kullanici_id = :kullanici_id,
                rapor_tarihi  = :rapor_tarihi,
                nedeni = :nedeni,
                rapor_baslangic  = :rapor_baslangic,
                rapor_bitis = :rapor_bitis,
                durum_id = :durum_id,
                bekler_id = :bekler_id
            
            WHERE rapor_id = :rapor_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'rapor_id' => $rapor_id,
                'kullanici_id' => $input['kullanici_id'],
                'rapor_tarihi' => $input['rapor_tarihi'],
                'nedeni' => $input['nedeni'],
                'rapor_baslangic' => $input['rapor_baslangic'],
                'rapor_bitis' => $input['rapor_bitis'],
                'durum_id' => $input['durum_id'],
                'bekler_id' => $input['bekler_id']
            ));
            return $statement->rowCount();
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }
    public function updateOnay(array $input)
    {
        $statement = "
            UPDATE rapor
            SET 
                durum_id = :durum_id,
                bekler_id = :bekler_id
            WHERE rapor_id = :rapor_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'rapor_id' => $input['rapor_id'],
                'durum_id' => $input['durum_id'],
                'bekler_id' => $input['bekler_id']
            ));
            return $statement->rowCount();
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function delete($rapor_id)
    {
        $statement = "
            DELETE FROM rapor
            WHERE rapor_id = :rapor_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array('rapor_id' => $rapor_id));
            return $statement->rowCount();
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }
}